/**
 * @description       : 
 * @author            : Ahmat Zulkifli Murad
 * @group             : 
 * @last modified on  : 07-27-2023
 * @last modified by  : Ahmat Zulkifli Murad
**/
@isTest
public with sharing class PresurveyServiceTEST {
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
    @isTest
    static void testScheduler() {

        Presurvey_Email_Setting__c  Presurvey_Email_Setting_template = new Presurvey_Email_Setting__c();
        Presurvey_Email_Setting_template.name = 'email_to_team_capacity_som';
        Presurvey_Email_Setting_template.CCAddress__c = 'PMO-EnterpriseProject@xl.co.id.invalid, Enterprise_Design_Planning@xl.co.id.invalid, XSIS.RIZKYR@xl.co.id, CTN.ESTIP@xl.co.id, SINGGIHN@xl.co.id';
        Presurvey_Email_Setting_template.Email_Template_Name__c = 'Presurvey_Waiting_Capacity_Assessment';
        Presurvey_Email_Setting_template.Sender__c ='Enterprise_Design_Planning@xl.co.id.invalid';
        Presurvey_Email_Setting_template.ToAddress__c = 'HERRYG@xl.co.id.invalid, usamah.ridha@saasten.com, syaiful.syafani@saasten.com';
        Presurvey_Email_Setting_template.Subject__c='[Presurvey] Request Allocation BUSOL %DATE%';
        Presurvey_Email_Setting_template.csvName__c='[Presurvey] Request Allocation BUSOL %DATE%.csv';
        insert Presurvey_Email_Setting_template;
        //System.debug('===== TestPresurveyWithTowerCandidate =====');
       // System.debug('===== Starting Setup Test Data =====');
        User usr=[SELECT id from user WHERE Profile.Name='System Administrator' and IsActive = TRUE LIMIT 1];
     
        Presurvey__c presurvey = new Presurvey__c(
            Customer_Name__c = generateRandomString(15),
            OwnerId = usr.id,
            Capacity__c = 10,
            UoM_Capacity__c = 'Mbps',
            Waiting_Capacity_Assessment_Date__c = Date.newInstance(2023, 1, 1),
            Presurvey_Status__c = 'Draft',
            Customer_Requirement__c = 'For Test Purposed Only.\nSingleRecord',
            Service_Group__c = 'NON GSM',
            Service__c = 'MPLS',
            Province_Site_A__c = 'Sumatera Selatan',
            City_Site_A__c = 'Kabupaten Musi Banyuasin',
            Coordinate_Site_A__Latitude__s=0,
            Coordinate_Site_A__Longitude__s=113.867569,
            Coordinate_Site_B__Latitude__s=0,
            Need_Tower_Candidate_Site_A__c=True,
            Coordinate_Site_B__Longitude__s=113.867569,
            Location_Site_A__c = generateRandomString(40) 
            );  
            insert presurvey;

            Tower_Candidate__c towerB = new Tower_Candidate__c(
            Candidate_Number__c = 1,                                                 // Candidate Number
            Presurvey__c = presurvey.id,                                                  // Presurvey
            Tower_ID__c = 'KAL-KT-MTW-0259',                                             // Tower ID
            Province__c = 'Kalimantan Tengah',                                           // Province
            Name = 'KAL-KT-MTW-0259-Site-B',                                             // Candidate Tower Name
            Kabupaten__c = 'Kab. Barito Utara',                                          // Kabupaten
            Router_ID__c = 'MA_KTMTW0259_01E',                                           // Router ID
            Kecamatan__c = 'Kec. Teweh Tengah',                                          // Kecamatan
            Air_Distance__c = 150624432,                                             // Air Distance
            Fiber_Distance__c = 27781260,                                            // Fiber Distance
            Select_For_Assessment__c = True, 
            IP_Loopback__c='32131313',                                             // Select for Assessment
            Source__c = 'Olympus',                                                       // Source
            Customer_Site__c = 'Site-B',                                                 // Customer Site
            Note_NPD__c = 'Need confirm capacity CSR & Port',                            // Note NPD
            Final_Review_Selection__c = false,                                           // Final Review Selection
            //Unique_Id_Tower_Candidate__c = presurvey.id+'Site-B',  // Unique Id Tower Candidate
            IsSent__c = false                                                           // IsSent
            );

            Tower_Candidate__c towerA = new Tower_Candidate__c(
            Candidate_Number__c = 1,                                                 // Candidate Number
            Presurvey__c = presurvey.id,                                                  // Presurvey
            Tower_ID__c = '123333',                                             // Tower ID
            Province__c = 'Kalimantan Tengah',                                           // Province
            Name = 'KAL-KT-MTW-0259-Site-A',                                             // Candidate Tower Name
            Kabupaten__c = 'Kab. Barito Utara',                                          // Kabupaten
            Router_ID__c = 'MA_KTMTW0259_01E',                                           // Router ID
            Kecamatan__c = 'Kec. Teweh Tengah',                                          // Kecamatan
            Air_Distance__c = 150624432,                                             // Air Distance
            Fiber_Distance__c = 27781260,                                            // Fiber Distance
            Select_For_Assessment__c = True,
            IP_Loopback__c= 'MA_KTMTW0259_01E',                                            // Select for Assessment
            Source__c = 'Olympus',                                                       // Source
            Customer_Site__c = 'Site-A',                                                 // Customer Site
            Note_NPD__c = 'MA_KTMTW0259_01E' ,                            // Note NPD
            Final_Review_Selection__c = false,                                           // Final Review Selection
               // Unique_Id_Tower_Candidate__c = presurvey.id+'Site-A',  // Unique Id Tower Candidate
            IsSent__c = false                                                           // IsSent
            );

            towerCandidateList.add(towerB);
            towerCandidateList.add(towerA);

            presurvey.Presurvey_Status__c='	Waiting Capacity Assessment';

            Update presurvey;

            insert towerCandidateList;
     
        Test.startTest();

        PresurveyService.sendEmailForCapacityAsessment(null);
        PresurveyService.sendEmailForCapacityAsessment(Datetime.newInstance(2023, 1, 1, 12, 30, 0));
        Test.stopTest();
    }
}