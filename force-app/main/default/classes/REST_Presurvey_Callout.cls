/**
 * @description       : 
 * @author            : Ahmad Aulia Fahmi
 * @group             : 
 * @last modified on  : 08-02-2023
 * @last modified by  : Ahmat Zulkifli Murad
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   31-05-2023   Ahmad Aulia Fahmi       Initial Version
 * 1.1   16-06-2023   Ahmad Aulia Fahmi       Update With New Field On Tower Candidate
 * 1.2   22-06-2023   Ahmad Aulia Fahmi       Enhance with new field on object tower candidate
**/

public with sharing class REST_Presurvey_Callout {

    public static List<Tower_Candidate__c> towerCandidateList = new List<Tower_Candidate__c>();
    public static string responseStatus;
    public static string responseMsg;
    public static string errorMsg;
    
    public class BodyRequest {
		public List<ValueSetBodyReq> pois;
 	}
    
    public class ValueSetBodyReq {
    	public String name;
      	public String code;
      	public Decimal latitude;
      	public Decimal longitude;
 	}
    
    public REST_Presurvey_Callout() {
        // no action in this constructor
    }
    
    public class DATA_TOWER_WRAPPER {
        public String idTower;
        public Decimal latitudeTower;
        public Decimal longitudeTower;
        public String provinceTower;
        public String kabupatenTower;
        public String kecamatanTower;
        public String hostnameCSRTower;
        public Decimal airDistanceTower;
        public Decimal fiberDistanceTower;
        public Decimal candidateTower;
        public String nameOfPOI;
    }

    public static string getAccessToken() {
        Datetime startDate = System.now();
        
        String callID = AppUtils.getNewGUID();
        String tokenStatusMsg = '';
        String result;
        String request;
        String endpoint;
        String token;
        string headerContentType;
        string headerCoockies;
    
        Http httpObj = new Http();
        HttpRequest httpRequestObj = new HttpRequest(); 
        Call_Log__c callLogObj = new Call_Log__c();
        try {  
            Olympus_API_Setting__c olympusGetAccessTokenSettings = Olympus_API_Setting__c.getValues('getAccessTokenOlympus'); // get getAccessTokenOlympus
            if(olympusGetAccessTokenSettings != null){
                endpoint = olympusGetAccessTokenSettings.URL__c + olympusGetAccessTokenSettings.URI__c;
                list<string> headerSplit = olympusGetAccessTokenSettings.header__c.split(';');

                if(headerSplit != null){
                    headerContentType = headerSplit[0].substringafter(': ');
                    headerCoockies = headerSplit[1].substringafter(': ');
                }
                
                httpRequestObj.setEndpoint( olympusGetAccessTokenSettings.URL__c + olympusGetAccessTokenSettings.URI__c );
                httpRequestObj.setHeader('Content-Type', headerContentType);
                httpRequestObj.setHeader('Cookie', headerCoockies);
                httpRequestObj.setMethod(olympusGetAccessTokenSettings.Method__c);
                httpRequestObj.setTimeout(120000);
                httpRequestObj.setBody('grant_type=' + olympusGetAccessTokenSettings.Grant_Type__c + 
                    '&client_secret=' + olympusGetAccessTokenSettings.Client_Secret__c + '&client_id=' +
                    olympusGetAccessTokenSettings.Client_ID__c );
                system.debug('httpRequestObj.setBody: ' + httpRequestObj);

                HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
                System.debug('httpResponseObj : '+ httpResponseObj);

                request = httpRequestObj.getBody();
                result = httpResponseObj.getBody();
    
                if (httpResponseObj.getStatusCode() == 200) {
                    Map<String, Object> responsemap = (Map<String, Object>) JSON.deserializeUntyped(httpResponseObj.getBody());
                    token = (String) responsemap.get('access_token');
                    tokenStatusMsg = 'Success';
                    
                } else {
                    tokenStatusMsg = 'Failed';
                }
            }
        } catch (Exception e) {
            //-- error handling for callout
            System.debug ('============== error found at REST_Presurvey_Callout Call-Out ==============');
    
            tokenStatusMsg = 'Failed';
            errorMsg = errorMsg +  '. Error on REST_Presurvey_Callout.getAccessToken method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            System.debug ('===== errorMsg : ' + errorMsg);
        }
    
        Datetime endDate = System.now();
    
        
        callLogObj.CallerFrom__c = 'Salesforce';
        callLogObj.Endpoint__c = endpoint; 
        callLogObj.Type__c = 'Callout';
        callLogObj.Request_Message__c = request.left(131072);
        callLogObj.Response_Message__c = result.left(131072);
        callLogObj.Method__c = 'POST';
        callLogObj.Status__c = tokenStatusMsg;
        callLogObj.Request_ID__c = callId;
        callLogObj.Request_Start_Time__c = startDate;
        callLogObj.Response_End_Time__c = endDate;
        
        //insert callLogObj;

        return token;   
    }

    @future(callout=true)
    public static void getTowerCandidates( String presurveyID ) { 
        System.debug(' == in calloutGetTowerCandidate == ');
        Datetime startDate = System.now(); // masih tidak sesuai sm gmt sekarang

        String callID = AppUtils.getNewGUID();
        String endPoint ;
        String responseMsg ;
        string responseStatus;
        String responseCallout = '';
        String result;
        String errorMsg;
        String request;
        String reqBody;
        string headerXCAuthorization;
        string headerContentType;
        string headerAuthorization;
        Integer statusCode = 200; //variable sample
        String idPresurvey = presurveyID; //uncomment if API already
        Decimal latSiteA, latSiteB, longSiteA, longSiteB;
        Boolean isMultiPoi = false;

        Set<String> recipientNotification = new Set<String>(); //untuk notification recipient
        recipientNotification.add(UserInfo.getUserId()); //insert data user kedalam Set ID
        String nameOfPresurvey;
        
        Map<String,List<String>> mapOfPOI = new Map<String,List<String>>();
        Map<String,List<String>> mapOfTower = new Map<String,List<String>>();

        // integer apiCallNumber = 0;
        Integer apiCallNumber;

        Presurvey_General_Setting__c countingCallout = Presurvey_General_Setting__c.getValues('Counting_Call_API');
        Call_Log__c callLogObj = new Call_Log__c();

        try{
            String tokenValue = getAccessToken(); // 

            //get data latitude and longitude presurvey
            System.debug('idPresurvey: ' + idPresurvey);
            Presurvey__c presurveyREC = [
                SELECT Id, Name, Coordinate_Site_A__latitude__s, update_source__c,
                    Coordinate_Site_A__longitude__s, Coordinate_Site_B__latitude__s, 
                    Coordinate_Site_B__longitude__s, Presurvey_Status__c, Get_Tower_API_Call_Number__c,
                    In_Progress_Status__c
                FROM Presurvey__c 
                WHERE Id =: idPresurvey
            ];
            
            nameOfPresurvey = presurveyREC.Name;
            latSiteA = presurveyREC.Coordinate_Site_A__Latitude__s;
            latSiteB = presurveyREC.Coordinate_Site_B__Latitude__s;
            longSiteA = presurveyREC.Coordinate_Site_A__Longitude__s;
            longSiteB = presurveyREC.Coordinate_Site_B__Longitude__s;
            //latSiteA = -7.135136; //variable sample
            //longSiteA = 111.595658; //variable sample

            Http httpObj = new Http();
            HttpRequest httpRequestObj = new HttpRequest();

            
            BodyRequest requestBody = new BodyRequest();
            requestBody.pois = new List<REST_Presurvey_Callout.ValueSetBodyReq>();
            
            if (latSiteB != null){ // untuk multi poi
                REST_Presurvey_Callout.ValueSetBodyReq actualData = new REST_Presurvey_Callout.ValueSetBodyReq();
                actualData.name = startDate + '_' + presurveyREC.Name + '-A';
                actualData.code = null;
                actualData.latitude = presurveyREC.Coordinate_Site_A__Latitude__s;
                actualData.longitude = presurveyREC.Coordinate_Site_A__Longitude__s;
                requestBody.pois.add(actualData);
                
            	REST_Presurvey_Callout.ValueSetBodyReq actualData2 = new REST_Presurvey_Callout.ValueSetBodyReq();
                actualData2.name = startDate + '_' + presurveyREC.Name + '-B';
                actualData2.code = null;
                actualData2.latitude = presurveyREC.Coordinate_Site_B__Latitude__s;
                actualData2.longitude = presurveyREC.Coordinate_Site_B__Longitude__s;
                requestBody.pois.add(actualData2);
                
                isMultiPoi = true;
                
            } else { // untuk single poi
            	REST_Presurvey_Callout.ValueSetBodyReq actualData = new REST_Presurvey_Callout.ValueSetBodyReq();
                actualData.name = startDate + '_' + presurveyREC.Name;
                actualData.code = null;
                actualData.latitude = presurveyREC.Coordinate_Site_A__Latitude__s;
                actualData.longitude = presurveyREC.Coordinate_Site_A__Longitude__s;
                requestBody.pois.add(actualData);
                
                isMultiPoi = false;
            }
                
            reqBody = JSON.serialize(requestBody);
            System.debug('>>> reqBody : '+ reqBody);

            Olympus_API_Setting__c olympusGetTowerAPISettings = Olympus_API_Setting__c.getValues('calloutGetTowerCandidate');
            if(olympusGetTowerAPISettings != null){
                endPoint = olympusGetTowerAPISettings.URL__c + olympusGetTowerAPISettings.URI__c;

                list<string> headerList = olympusGetTowerAPISettings.header__c.split(';');
                
                if(headerList != null){
                    headerXCAuthorization = headerList[0].substringAfter(': ');
                    headerContentType = headerList[1].substringAfter(': ');
                }
                
                httpRequestObj.setEndpoint(olympusGetTowerAPISettings.URL__c + olympusGetTowerAPISettings.URI__c );
                // httpRequestObj.setEndpoint(olympusGetTowerAPISettings.End_Point__c);

                httpRequestObj.setHeader('xc-authorization', headerXCAuthorization);
                httpRequestObj.setHeader('Content-Type', headerContentType); // kalau mau coba negative test di comment (dapiae2e9d4541c4930ea649e22667b68361)
                // system.debug('tokenValue: '  + tokenValue);
                httpRequestObj.setHeader('Authorization', 'Bearer ' + tokenValue); // kalau mau coba negative test di comment (dapiae2e9d4541c4930ea649e22667b68361)
                // httpRequestObj.setHeader('Authorization', 'Bearer dapiae2e9d4541c4930ea649e22667b68361'); // kalau mau coba negative test di comment (dapiae2e9d4541c4930ea649e22667b68361)
                
                httpRequestObj.setBody(reqBody);
                httpRequestObj.setMethod(olympusGetTowerAPISettings.method__c);
                httpRequestObj.setTimeout(Integer.valueOf(olympusGetTowerAPISettings.Timeout__c));
                
                HttpResponse httpResponseObj = httpObj.send(httpRequestObj);
                system.debug('httpResponseObj: ' + httpResponseObj);

                request = String.ValueOf(httpRequestObj);
        
                responseCallout = httpResponseObj.getBody();
                System.debug('>>>> responseCallout : ' + responseCallout);
                result = responseCallout;
                
                if (httpResponseObj.getStatusCode() == 200){ //httpResponseObj.getStatusCode() statusCode
                    
                    Map<String,Object> responseAPI = (Map<String,Object>)JSON.deserializeUntyped(responseCallout); //proses deserialize
                    List<Object> resultJSON = (List<Object>)responseAPI.get('result'); //mengambil data result dari response call api
                    System.debug('resultJSON' + responseAPI.get('result'));
                    
                    if (resultJSON != null) { //jika result response call api tidak kosong
                        List<DATA_TOWER_WRAPPER> listOfTower = new List<DATA_TOWER_WRAPPER>(); //inisialisasi list string untuk dimasukan ke dalam map
                        
                        for (Object resultJSONObj : resultJSON) { // perulangan untuk mendapatkan data dari result
                            Map<String,Object> resultJSONObjMap = (Map<String,Object>)resultJSONObj;
                            Map<String,Object> poiData = (Map<String,Object>)resultJSONObjMap.get('poi'); //get all data of poi
                            List<Object> towerData = (List<Object>)resultJSONObjMap.get('towers'); //get all data of towers

                            String codePOI = (String) poiData.get('code'); //insert poi code to variable
                            String namePOI = (String) poiData.get('name'); //insert poi name to variable
                            Decimal latitudePOI = (Decimal) poiData.get('latitude'); //insert poi latitude to variable
                            Decimal longitudePOI = (Decimal) poiData.get('longitude'); //insert poi longitude to variable
                            
                            List<String> listOfPOI = new List<String>(); //inisialisasi list string untuk dimasukan ke dalam map
                            listOfPOI.add(codePOI); //memasukan code poi kedalam list
                            listOfPOI.add(namePOI); //memasukan name poi kedalam list
                            listOfPOI.add(String.valueOf(latitudePOI)); //memasukan latitude poi kedalam list
                            listOfPOI.add(String.valueOf(longitudePOI)); //memasukan longitude poi kedalam list
                            mapOfPOI.put(namePOI, listOfPOI); //memasukan list poi kedalam map dengan key name of poi, dapat diubah sesuai kebutuhan
                            
                            for (Object dataTowers: towerData){ //looping for get all data of towers like id, name dll
                                DATA_TOWER_WRAPPER dataTowerObj = new DATA_TOWER_WRAPPER();

                                Map<String,Object> resultTowersData = (Map<String,Object>)dataTowers;
                                dataTowerObj.idTower = (String) resultTowersData.get('id'); //get ID Tower
                                dataTowerObj.latitudeTower = (Decimal) resultTowersData.get('latitude'); //get Latitude Tower
                                dataTowerObj.longitudeTower = (Decimal) resultTowersData.get('longitude'); //get Longitude Tower
                                dataTowerObj.provinceTower = (String) resultTowersData.get('province'); //get Province Tower
                                dataTowerObj.kabupatenTower = (String) resultTowersData.get('kabupaten'); //get Kabupaten Tower
                                dataTowerObj.kecamatanTower = (String) resultTowersData.get('kecamatan'); //get Kecamatan Tower
                                dataTowerObj.hostnameCSRTower = (String) resultTowersData.get('hostname_csr'); //get Hostname_csr Tower
                                dataTowerObj.airDistanceTower = (Decimal) resultTowersData.get('air_distance'); //get air_distance Tower
                                dataTowerObj.fiberDistanceTower = (Decimal) resultTowersData.get('fiber distance'); //get fiber distance Tower
                                dataTowerObj.candidateTower = (Decimal) resultTowersData.get('candidate'); //get candidate Tower
                                dataTowerObj.nameOfPOI = namePOI;
                                listOfTower.add(dataTowerObj);
                            }
                            // delete tower candidate in related presurvey
                            removeTowerfromPresurvey(idPresurvey);
                            // insert new tower candidate
                            addCandidateTowertoPresurvey(listOfTower, idPresurvey, isMultiPoi);
                        }
                        System.debug('listOfTower: ' + listOfTower);
                        System.debug('idPresurvey: ' + idPresurvey);
                        System.debug('isMultiPoi: ' + isMultiPoi);
                    } else {
                        system.debug('null.. : ' + resultJSON);
                    }

                    responseStatus = 'Success';
                    presurveyREC.In_Progress_Status__c = 'Request is Success';
                } else {
                    responseStatus = 'Failed';
                    //result = httpResponseObj.getStatus();
                }

                // set API call number (increase)
                apiCallNumber = (integer.valueOf(presurveyREC.Get_Tower_API_Call_Number__c) == null) ? 0: integer.valueOf(presurveyREC.Get_Tower_API_Call_Number__c) + 1;
                presurveyREC.Get_Tower_API_Call_Number__c = apiCallNumber;
            }
            
            // send error notification if status call api failed
            if (responseStatus != 'Success') {
                /* OLD 
                presurveyREC.Presurvey_Status__c = 'Draft';

                sendNotification(recipientNotification, idPresurvey, nameOfPresurvey, Label.PRESURVEY_GET_TOWER_FAILED_NOTIF_TITLE_ENG, Label.PRESURVEY_GET_TOWER_FAILED_NOTIF_ENG);
                sendEmailNotification(idPresurvey);
                */


                // if call is not success then create schedule for next call
                Integer API_CALL_MAX_for_GET_TOWER = integer.valueOf(countingCallout.API_Call_Max_for_Get_Tower__c); //TODO : change this statement to get value from custom setting
                Integer API_Call_Interval_for_Get_Tower = integer.valueOf(countingCallout.API_Call_Interval_for_Get_Tower__c); // (minutes) TODO : change this statement to get value from custom setting

                if (apiCallNumber < API_CALL_MAX_for_GET_TOWER) {
                    // create scheduler!
                    Datetime nextSchedule = system.now().addMinutes(API_Call_Interval_for_Get_Tower);

                    system.debug ('============ nextSchedule :' + nextSchedule);
                    String sYear = string.valueof( nextSchedule.year() );
                    String sMonth = string.valueof( nextSchedule.month() );
                    String sDay = string.valueof( nextSchedule.day() ); 
                    String sHour = string.valueof( nextSchedule.Hour() );
                    String sMinute = string.valueof( nextSchedule.minute() );
                    String sSecond = string.valueOf( nextSchedule.second() );
                    
                    Schedule_GetTowerCandidate getTowerCandidateSCH = new Schedule_GetTowerCandidate();
                    getTowerCandidateSCH.presurveyID = presurveyID;

                    String sch = sSecond + ' ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
                    system.debug ('============ sch :' + sch);
                    
                    String jobTitle = 'Get Tower Candidate : ' + presurveyID + 
                        ' : ' + (apiCallNumber + 1) +
                        ' : ' + sch
                        ;
                    system.debug ('============ jobTitle :' + jobTitle);
                    
                    //-- create scheduler
                    String jobID = system.schedule(jobTitle, sch, getTowerCandidateSCH);
                    //TODO: put the job title and jobID in calllog >> Done di bawah
                } else {
                    presurveyREC.In_Progress_Status__c = 'Request is Failed'; // if callout 3 times
                    sendEmailNotification(idPresurvey);
                }
            } else {
                System.debug('dont update status presurvey');
                presurveyREC.update_source__c = 'User';

                sendNotification(recipientNotification, idPresurvey, nameOfPresurvey, Label.PRESURVEY_GET_TOWER_SUCCESS_NOTIF_TITLE_ENG, Label.PRESURVEY_GET_TOWER_SUCCESS_NOTIF_ENG); 
            }


            // update presurvey record 
            system.debug('===Get_Tower_API_Call_Number__c: ' + presurveyREC.Get_Tower_API_Call_Number__c);
            Update presurveyREC;
            
        } catch(Exception e) {
            //-- error handling for callout
            SYSTEM.DEBUG ('============== error found at Call-Out ==============');

            responseStatus = 'Failed';
            errorMsg = errorMsg +  '. Error on REST_Presurvey_Callout.REST_Presurvey_Callout method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }

        //Save call information to call log
        Datetime endDate = System.now();
    
        callLogObj.CallerFrom__c = 'Salesforce';
        callLogObj.Endpoint__c = endPoint; 
        callLogObj.Type__c = 'Callout';
        callLogObj.Request_Message__c = (reqBody != null) ? reqBody.left(131072) : '';
        callLogObj.Response_Message__c = (result != null) ? result.left(131072) : '';
        callLogObj.Method__c = 'POST';
        callLogObj.Status__c = responseStatus;
        callLogObj.Request_ID__c = callId;
        callLogObj.Request_Start_Time__c = startDate;
        callLogObj.Response_End_Time__c = endDate;
        callLogObj.Presurvey_Related__c = idPresurvey;
        
        insert callLogObj;
    }
    
    // handling notification if call API failed
    public static void sendNotification(Set<String> recipientsId, String recordId, String nameOfPresurvey, String setTitle, String setBody){
        System.debug('----in sendNotifivation----');
        
        // Get the Id for our custom notification type
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName = 'Presurvey_Notification_Get_Tower_Candidate'];
        
        // Create a new custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle(setTitle);
        notification.setBody(nameOfPresurvey + ' - ' + setBody);
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(recordId);
        
        // Actually send the notification
        try {
            notification.send(recipientsId);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
    
    // handling email notification if call api failed
    public static void sendEmailNotification(String presurveyID){
        System.debug('===In sendEmailNotification===');
        
        // delete before deploy prod << tidak dihapus ya :ahmat
        Presurvey_Email_Setting__c emailSetting = Presurvey_Email_Setting__c.getValues('notification_error_sendEmail');

        //setup general email
        EmailTemplate emailTemp = [SELECT Id,Subject,Description,HtmlValue,DeveloperName,Body 
        FROM EmailTemplate 
        WHERE developername =: emailSetting.Email_Template_Name__c];

        Call_Log__c callLogObj = new Call_Log__c();

        try {
            Presurvey__c presurveyList = [SELECT Id, Name, OwnerId, Owner.Name, Account__c, Customer_Name__c, Presurvey_Status__c, Link_ID_info__c 
                                        FROM Presurvey__c
                                        WHERE Id =: presurveyID];
            
            // set email
            List<String> setToAdrress = new List<String>();
            List<String> setCCAdrress = new List<String>();
            List<String> setBCCAdrress = new List<String>();
            
            if (emailSetting.ToAddress__c != null) {
                setToAdrress = emailSetting.ToAddress__c.split(',');
            }
            if (emailSetting.CCAddress__c != null) {
                setCCAdrress = emailSetting.CCAddress__c.split(',');
            }
            if (emailSetting.BCCAddress__C != null) {
                setBCCAdrress = emailSetting.BCCAddress__C.split(',');
            }
            
            // process for sending email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setWhatId(presurveyID);
            email.setTargetObjectId(presurveyList.OwnerId);
            email.setTemplateId(emailTemp.Id);
            email.setToAddresses(setToAdrress);
            email.setCcAddresses(setCCAdrress);
            email.setBccAddresses(setBCCAdrress);
            email.setTreatTargetObjectAsRecipient(false);
            email.setUseSignature(false);
            email.setSaveAsActivity(false);
            
            Messaging.SendEmailResult[] resultEmail = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
            responseStatus = 'Success';

            callLogObj.sent_email_if_failed__c = false;
            callLogObj.Request_Message__c = ('Subject: ' + emailTemp.Subject + ' ID: ' + presurveyID).left(131070);
            callLogObj.Response_Message__c = 'is Success = ' + resultEmail[0].issuccess();

        } catch (Exception e) {
            SYSTEM.DEBUG ('============== error found at Call-Out ==============');

            callLogObj.Request_Message__c = ('Subject: ' + emailTemp.Subject + ' ID: ' + presurveyID).left(131070);
            callLogObj.Response_Message__c = e.getmessage() + ' in line: ' + e.getLineNumber();

            responseStatus = 'Failed';
            errorMsg = errorMsg +  '. Error on REST_Presurvey_Callout.REST_Presurvey_Callout method.::' +  e.getmessage() + ' - ' +e.getStacktraceString() +' ' + responseMsg +'::' + e.getLineNumber();
            apputils.puterror(errorMsg);
            SYSTEM.DEBUG ('===== errorMsg : ' + errorMsg);
        }

        //Save call information to call log
    
        callLogObj.CallerFrom__c = 'Salesforce';
        callLogObj.Type__c = 'Email';
        callLogObj.Status__c = responseStatus;
        callLogObj.Request_Start_Time__c = Datetime.now();
        callLogObj.Response_End_Time__c = Datetime.now();
        
        //insert callLogObj;
    }
    
    public static void addCandidateTowertoPresurvey(List<DATA_TOWER_WRAPPER> listOfDataWrapper, String idPresurvey, Boolean isMultiPoi){
        List<Tower_Candidate__c> candidateTowerList = new List<Tower_Candidate__c>();

        if (listOfDataWrapper.size() > 0) {
            for (DATA_TOWER_WRAPPER towerCandidateReq : listOfDataWrapper) {
                Tower_Candidate__c sobjTowerCandidate = new Tower_Candidate__c(); //prepareration for data to tower candidate
    
                sobjTowerCandidate.Candidate_Number__c = towerCandidateReq.candidateTower;
                sobjTowerCandidate.Tower_ID__c = towerCandidateReq.idTower;
                sobjTowerCandidate.Presurvey__c = idPresurvey;
                sobjTowerCandidate.Name = isMultiPoi == true ? towerCandidateReq.idTower + '-Site' + towerCandidateReq.nameOfPOI.right(2) : towerCandidateReq.idTower;//idTowerCandidate + '-Site' + specificSite : idTowerCandidate;
                sobjTowerCandidate.Router_ID__c = towerCandidateReq.hostnameCSRTower;
                sobjTowerCandidate.Air_Distance__c = towerCandidateReq.airDistanceTower;
                sobjTowerCandidate.Fiber_Distance__c = towerCandidateReq.fiberDistanceTower;//.setScale(3, RoundingMode.HALF_UP);
                sobjTowerCandidate.Province__c = towerCandidateReq.provinceTower;
                sobjTowerCandidate.Kabupaten__c = towerCandidateReq.kabupatenTower;
                sobjTowerCandidate.Kecamatan__c = towerCandidateReq.kecamatanTower;
                sobjTowerCandidate.Coordinate__latitude__s = towerCandidateReq.latitudeTower;
                sobjTowerCandidate.Coordinate__longitude__s = towerCandidateReq.longitudeTower;
                sobjTowerCandidate.Source__c = 'Olympus';
                sobjTowerCandidate.Customer_Site__c = isMultiPoi == true ? 'Site' + towerCandidateReq.nameOfPOI.right(2) : 'Site-A';
                sobjTowerCandidate.Select_For_Assessment__c = false;
                sobjTowerCandidate.Unique_Id_Tower_Candidate__c = sobjTowerCandidate.Presurvey__c + '_' + sobjTowerCandidate.Tower_ID__c + '_' + sobjTowerCandidate.Customer_Site__c;
                
                candidateTowerList.add(sobjTowerCandidate); //add to list
                System.debug('candidateTowerList: ' + candidateTowerList);
            }
            insert candidateTowerList;
        }
    }

    public static void removeTowerfromPresurvey(String idPresurvey){
        if (idPresurvey != null && idPresurvey != '') {
            // query presurvey cari tower candidat berdasarkan presurvey
            List<Tower_Candidate__c> getTowerCandidatebyPresurvey = [select id, name, presurvey__c from tower_candidate__c where presurvey__c =: idPresurvey];
            
            // delete
            delete getTowerCandidatebyPresurvey;
        }
    }

}