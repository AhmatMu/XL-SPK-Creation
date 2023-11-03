/**
 * @description       : 
 * @author            : M Bustamil Adam 
 * @group             : 
 * @last modified on  : 08-01-2023
 * @last modified by  : Ahmat Zulkifli Murad
**/
@isTest
public class REST_Presurvey_CalloutTEST {
    
    public static List<Tower_Candidate__c> towerCandidateList = new List<Tower_Candidate__c>();

    @testVisible    
    private static String generateRandomString(Integer len) {
        final String chars = 'xaxPmno2IDdEwLzbtEvhv6oG1RDT6xQJX3MvF4amaDQ9TUvHgJfdbodlllPTnnuw';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
    
    @testVisible
    private static String generateRandomNumber(Integer len) {
        final String chars = '0129875346';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
     } 

    @TestSetup
    public static void makeData(){
        Presurvey_General_Setting__c generalSetting = new Presurvey_General_Setting__c(
            Name = 'Counting_Call_API',
            API_Call_Interval_for_Get_Tower__c = 1,
            API_Call_Max_for_Get_Tower__c = 3
        );

        insert generalSetting;

        Presurvey_Email_Setting__c Presurvey_Email_SettingRec = new Presurvey_Email_Setting__c();
        Presurvey_Email_SettingRec.name = 'notification_error_sendEmail';
        Presurvey_Email_SettingRec.ToAddress__c = 'xsis.rizkyr@xl.co.id.invalid, singgihn@xl.co.id.invalid, MBA.FADLYF@xl.co.id.invalid, xenam@xl.co.id.invalid';
        Presurvey_Email_SettingRec.BCCAddress__c = 'usamah.ridha@saasten.com, syaiful.syafani@saasten.com, doddy.kusumadhynata@saasten.com.invalid';
        Presurvey_Email_SettingRec.Email_Template_Name__c = 'Presurvey_Handling_Email_Error_From_API';

        insert Presurvey_Email_SettingRec;

    }

    @isTest
    static void testApexCallout() {
        // ... Your test method code ...

        String EmailTest='test@gmail.com';

        Olympus_API_Setting__c  Olympus_APISetting_TowerCandidate = new Olympus_API_Setting__c();
        Olympus_APISetting_TowerCandidate.Name = 'calloutGetTowerCandidate';
        Olympus_APISetting_TowerCandidate.end_point__c = 'https://olympus.xlaxiata.id/sit/fiber-route/sales-force';
        Olympus_APISetting_TowerCandidate.Method__c = 'POST';
        Olympus_APISetting_TowerCandidate.Timeout__c = 120000;
        Olympus_APISetting_TowerCandidate.Token_Key__c = 'dapiae2e9d4541c4930ea649e22667b68361';
        Olympus_APISetting_TowerCandidate.uri__c = '/proxy-olympus/v1/post-fibersalesforce';
        Olympus_APISetting_TowerCandidate.url__c = 'https://gateway.egw.xl.co.id';
        Olympus_APISetting_TowerCandidate.header__c = 'xc-authorization: Bearer dapiae2e9d4541c4930ea649e22667b68361; Content-Type: application/json';
        insert Olympus_APISetting_TowerCandidate;

        Olympus_API_Setting__c olympusGetAccessTokenSettings = new Olympus_API_Setting__c();
        olympusGetAccessTokenSettings.Name = 'getAccessTokenOlympus';
        olympusGetAccessTokenSettings.end_point__c = 'https://olympus.xlaxiata.id/sit/fiber-route/sales-force';
        olympusGetAccessTokenSettings.Method__c = 'POST';
        olympusGetAccessTokenSettings.Timeout__c = 120000;
        olympusGetAccessTokenSettings.Token_Key__c = 'dapiae2e9d4541c4930ea649e22667b68361';
        olympusGetAccessTokenSettings.uri__c = '/oauth';
        olympusGetAccessTokenSettings.url__c = 'https://gateway.egw.xl.co.id';
        olympusGetAccessTokenSettings.Client_ID__c = 'FdKNuFjwgfYlpL4uEjL5rxBJwKQa';
        olympusGetAccessTokenSettings.Client_Secret__c = 'cB8WEz3Y5uuJVIgn03KFa6PkBYwa';
        olympusGetAccessTokenSettings.Grant_Type__c = 'client_credentials';
        olympusGetAccessTokenSettings.header__c = 'Content-Type: application/x-www-form-urlencoded; Cookie: __cf_bm=zaKnz2ZaF6TMEU908iX9vKTnG5yWOZZY_JF0T9vshKs-1687253639-0-AfHwWGAX5oofrhxkXdoW+Zn15PRLoWRYD8R8AEegGQPsto7klDqHJhcqEMDfu8wAL8nSALAoiIt9rZjQLF9/WTw=';

        insert olympusGetAccessTokenSettings;

        User usr=[SELECT id from user WHERE Profile.Name='System Administrator' and IsActive = TRUE LIMIT 1];
       
      
        Presurvey__c presurvey = new Presurvey__c(
            Customer_Name__c = generateRandomString(15),
            OwnerId = usr.id,
            Capacity__c = 10,
            UoM_Capacity__c = 'Mbps',
            Presurvey_Status__c = 'Submit',
            Customer_Requirement__c = 'For Test Purposed Only.\nSingleRecord',
            Service_Group__c = 'NON GSM',
            Service__c = 'LL',
            Province_Site_A__c = 'Sumatera Selatan',
            City_Site_A__c = 'Kabupaten Musi Banyuasin',
            Province_Site_B__c = 'DKI Jakarta',
            City_Site_B__c = 'Kota Administrasi Jakarta Selatan',
            Coordinate_Site_A__Latitude__s = 0,
            Coordinate_Site_A__Longitude__s = 113.867569,
            Coordinate_Site_B__Latitude__s = 6.1668188,
            Need_Tower_Candidate_Site_A__c = True,
            Get_Tower_API_Call_Number__c = 0,
            Coordinate_Site_B__Longitude__s = 106.8029624,
            Location_Site_B__c = generateRandomString(40), 
            Location_Site_A__c = generateRandomString(40) 
            ); 
        insert presurvey;

        // Mock the HTTP callout response for the getTowerCandidates method
        Test.setMock(HttpCalloutMock.class, new TowerCandidatesHttpMockSuccess());

        // Call the getTowerCandidates method from the REST_Presurvey_Callout class
        Test.startTest();
        REST_Presurvey_Callout.getTowerCandidates(presurvey.Id);
        Test.stopTest();

        // Verify that Tower_Candidate__c records are created for the Presurvey
        List<Tower_Candidate__c> candidates = [
            SELECT Id, Candidate_Number__c, Tower_ID__c, Presurvey__c, Name, Router_ID__c, Air_Distance__c,
                Fiber_Distance__c, Province__c, Kabupaten__c, Kecamatan__c, Coordinate__latitude__s, Coordinate__longitude__s,
                Source__c, Customer_Site__c, Select_For_Assessment__c, Unique_Id_Tower_Candidate__c
            FROM Tower_Candidate__c
            WHERE Presurvey__c = :presurvey.Id
        ];
        System.assertEquals(6, candidates.size()); // Assuming 6 tower candidates are returned from the mock response
    }

    private class TowerCandidatesHttpMockSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"OK","message":"","result":[{"poi":{"name":"2023-07-14 08:00:56_Presurvey-032021-016-A","code":null,"latitude":0.0,"longitude":113.867569},"towers":[{"id":"KAL-KT-MTW-0259","latitude":-0.895608,"longitude":114.883889,"province":"Kalimantan Tengah","kabupaten":"Kab. Barito Utara","kecamatan":"Kec. Teweh Tengah","hostname_csr":"MA_KTMTW0259_01E","air_distance":150624.4318633093,"fiber distance":277812.6,"candidate":1.0},{"id":"KAL-KT-MTW-0256","latitude":-0.872639,"longitude":114.929278,"province":"Kalimantan Tengah","kabupaten":"Kab. Barito Utara","kecamatan":"Kec. Lahei","hostname_csr":"MA_KTMTW0256_01E","air_distance":152812.64596723844,"fiber distance":282542.7,"candidate":2.0},{"id":"KAL-KT-MTW-0258","latitude":-0.956417,"longitude":114.892828,"province":"Kalimantan Tengah","kabupaten":"Kab. Barito Utara","kecamatan":"Kec. Teweh Tengah","hostname_csr":"MA_KTMTW0258_01E","air_distance":155902.7366565467,"fiber distance":286982.1,"candidate":3.0}]},{"poi":{"name":"2023-07-14 08:00:56_Presurvey-032021-016-B","code":null,"latitude":0.0,"longitude":106.832599},"towers":[{"id":"SUM-BB-SGL-0186","latitude":-1.565211,"longitude":105.842839,"province":"Kepulauan Bangka Belitung","kabupaten":"Kab. Bangka","kecamatan":"Kec. Belinyu","hostname_csr":"MA-BB3275200G9-01H","air_distance":205913.8690952205,"fiber distance":13375.3,"candidate":1.0},{"id":"SUM-BB-SGL-0471","latitude":-1.594225,"longitude":105.842656,"province":"Kepulauan Bangka Belitung","kabupaten":"Kab. Bangka","kecamatan":"Kec. Belinyu","hostname_csr":"MA-JB3276320G9-01H","air_distance":208658.3264146364,"fiber distance":18215.0,"candidate":2.0},{"id":"SUM-BB-SGL-0202","latitude":-1.6825,"longitude":105.985528,"province":"Kepulauan Bangka Belitung","kabupaten":"Kab. Bangka","kecamatan":"Kec. Riau Silip","hostname_csr":"MA-BB3275070G9-01H","air_distance":209452.0858760076,"fiber distance":71754.3,"candidate":3.0}]}]}');
            return res;
        }
    }

    @isTest
    static void testApexCalloutFailed() {
        // ... Your test method code ...

        String EmailTest='test@gmail.com';

        Olympus_API_Setting__c  Olympus_APISetting_TowerCandidate = new Olympus_API_Setting__c();
        Olympus_APISetting_TowerCandidate.Name = 'calloutGetTowerCandidate';
        Olympus_APISetting_TowerCandidate.end_point__c = 'https://olympus.xlaxiata.id/sit/fiber-route/sales-force.invalid'; // invalid
        Olympus_APISetting_TowerCandidate.Method__c = 'POST';
        Olympus_APISetting_TowerCandidate.Timeout__c = 120000;
        Olympus_APISetting_TowerCandidate.Token_Key__c = 'dapiae2e9d4541c4930ea649e22667b68361';
        Olympus_APISetting_TowerCandidate.uri__c = '/proxy-olympus/v1/post-fibersalesforce.invalid'; // invalid
        Olympus_APISetting_TowerCandidate.url__c = 'https://gateway.egw.xl.co.id';
        Olympus_APISetting_TowerCandidate.header__c = 'xc-authorization: Bearer dapiae2e9d4541c4930ea649e22667b68361; Content-Type: application/json';
        insert Olympus_APISetting_TowerCandidate;

        Olympus_API_Setting__c olympusGetAccessTokenSettings = new Olympus_API_Setting__c();
        olympusGetAccessTokenSettings.Name = 'getAccessTokenOlympus';
        olympusGetAccessTokenSettings.end_point__c = 'https://olympus.xlaxiata.id/sit/fiber-route/sales-force.invalid'; // invalid
        olympusGetAccessTokenSettings.Method__c = 'POST';
        olympusGetAccessTokenSettings.Timeout__c = 120000;
        olympusGetAccessTokenSettings.Token_Key__c = 'dapiae2e9d4541c4930ea649e22667b68361';
        olympusGetAccessTokenSettings.uri__c = '/oauth.invalid'; // invalid
        olympusGetAccessTokenSettings.url__c = 'https://gateway.egw.xl.co.id';
        olympusGetAccessTokenSettings.Client_ID__c = 'FdKNuFjwgfYlpL4uEjL5rxBJwKQa';
        olympusGetAccessTokenSettings.Client_Secret__c = 'cB8WEz3Y5uuJVIgn03KFa6PkBYwa';
        olympusGetAccessTokenSettings.Grant_Type__c = 'client_credentials';
        olympusGetAccessTokenSettings.header__c = 'Content-Type: application/x-www-form-urlencoded; Cookie: __cf_bm=zaKnz2ZaF6TMEU908iX9vKTnG5yWOZZY_JF0T9vshKs-1687253639-0-AfHwWGAX5oofrhxkXdoW+Zn15PRLoWRYD8R8AEegGQPsto7klDqHJhcqEMDfu8wAL8nSALAoiIt9rZjQLF9/WTw=';

        insert olympusGetAccessTokenSettings;

        User usr=[SELECT id from user WHERE Profile.Name='System Administrator' and IsActive = TRUE LIMIT 1];
       
      
        Presurvey__c presurvey = new Presurvey__c(
            Customer_Name__c = generateRandomString(15),
            OwnerId = usr.id,
            Capacity__c = 10,
            UoM_Capacity__c = 'Mbps',
            Presurvey_Status__c = 'Submit',
            Customer_Requirement__c = 'For Test Purposed Only.\nSingleRecord',
            Service_Group__c = 'NON GSM',
            Service__c = 'LL',
            Province_Site_A__c = 'Sumatera Selatan',
            City_Site_A__c = 'Kabupaten Musi Banyuasin',
            Province_Site_B__c = 'DKI Jakarta',
            City_Site_B__c = 'Kota Administrasi Jakarta Selatan',
            Coordinate_Site_A__Latitude__s=0,
            Coordinate_Site_A__Longitude__s=113.867569,
            Coordinate_Site_B__Latitude__s=6.1668188,
            Need_Tower_Candidate_Site_A__c=True,
            Coordinate_Site_B__Longitude__s=106.8029624,
            Location_Site_B__c = generateRandomString(40), 
            Location_Site_A__c = generateRandomString(40) 
            ); 
        insert presurvey;

        // Mock the HTTP callout response for the getTowerCandidates method
        Test.setMock(HttpCalloutMock.class, new TowerCandidatesHttpMockFailed());

        // Call the getTowerCandidates method from the REST_Presurvey_Callout class
        Test.startTest();
        REST_Presurvey_Callout.getTowerCandidates(presurvey.Id);
        Test.stopTest();

        // Verify that Tower_Candidate__c records are created for the Presurvey
        List<Tower_Candidate__c> candidates = [
            SELECT Id, Candidate_Number__c, Tower_ID__c, Presurvey__c, Name, Router_ID__c, Air_Distance__c,
                Fiber_Distance__c, Province__c, Kabupaten__c, Kecamatan__c, Coordinate__latitude__s, Coordinate__longitude__s,
                Source__c, Customer_Site__c, Select_For_Assessment__c, Unique_Id_Tower_Candidate__c
            FROM Tower_Candidate__c
            WHERE Presurvey__c = :presurvey.Id
        ];
        // System.assertEquals(6, candidates.size()); // Assuming 6 tower candidates are returned from the mock response
    }

    private class TowerCandidatesHttpMockFailed implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(502);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"Failed","message":"","result":null}');
            return res;
        }
    }

}