/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-18-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class TowerCandidateTriggerTEST {
    public static List<Tower_Candidate__c> towerCandidateList = new List<Tower_Candidate__c>();
    public static List<Tower_Candidate__c> towerCandidateList2 = new List<Tower_Candidate__c>();
    public static List<Tower_Candidate__c> towerCandidateList3 = new List<Tower_Candidate__c>();
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
Static void  TestPresurveyWithTowerCandidate(){
        System.debug('===== TestPresurveyWithTowerCandidate =====');
        System.debug('===== Starting Setup Test Data =====');
        User usr=[SELECT id from user WHERE Profile.Name='System Administrator' and IsActive = TRUE LIMIT 1];
        //Account acc =[SELECT id,Name from Account where Ownerid=:usr.id AND Organization_Type__c='Head Office' LIMIT 1];
        //AM_Portfolio_Mapping__c solmapp = [SELECT id,Portfolio_Management_Support__c,AM__c,Status__c from AM_Portfolio_Mapping__c where AM__c=:usr.id AND  Status__c = 'Active' LIMIT 1];
        
        
        // Test Case 1 
        Presurvey__c presurvey = new Presurvey__c(
        Customer_Name__c = generateRandomString(15),
        OwnerId = usr.id,
        Capacity__c = 10,
        UoM_Capacity__c = 'Mbps',
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
         IP_Loopback__c='',                                             // Select for Assessment
         Source__c = 'Olympus',                                                       // Source
         Customer_Site__c = 'Site-B',                                                 // Customer Site
         Note_NPD__c = 'Need confirm capacity CSR & Port',                            // Note NPD
         Final_Review_Selection__c = false,                                           // Final Review Selection
        //Unique_Id_Tower_Candidate__c = presurvey.id+'Site-B',  // Unique Id Tower Candidate
         IsSent__c = false                                                           // IsSent
         );

        Tower_Candidate__c towerAtwrIdNUll = new Tower_Candidate__c(
        Candidate_Number__c = 1,                                                 // Candidate Number
        Presurvey__c = presurvey.id,                                                  // Presurvey
        Tower_ID__c = null,                                             // Tower ID
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

        Tower_Candidate__c towerAtRouterNUll = new Tower_Candidate__c(
            Candidate_Number__c = 1,                                                 // Candidate Number
            Presurvey__c = presurvey.id,                                                  // Presurvey
            Tower_ID__c = 'MA_KTMTW0259_01E',                                             // Tower ID
            Province__c = 'Kalimantan Tengah',                                           // Province
            Name = 'KAL-KT-MTW-0259-Site-A',                                             // Candidate Tower Name
            Kabupaten__c = 'Kab. Barito Utara',                                          // Kabupaten
            Router_ID__c = Null,                                           // Router ID
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

            Tower_Candidate__c towerAipLoopBackNull = new Tower_Candidate__c(
            Candidate_Number__c = 1,                                                 // Candidate Number
            Presurvey__c = presurvey.id,                                                  // Presurvey
            Tower_ID__c = 'MA_KTMTW0259_01E',                                             // Tower ID
            Province__c = 'Kalimantan Tengah',                                           // Province
            Name = 'KAL-KT-MTW-0259-Site-A',                                             // Candidate Tower Name
            Kabupaten__c = 'Kab. Barito Utara',                                          // Kabupaten
            Router_ID__c ='MA_KTMTW0259_01E' ,                                           // Router ID
            Kecamatan__c = 'Kec. Teweh Tengah',                                          // Kecamatan
            Air_Distance__c = 150624432,                                             // Air Distance
            Fiber_Distance__c = 27781260,                                            // Fiber Distance
            Select_For_Assessment__c = True,
            IP_Loopback__c= Null,                                            // Select for Assessment
            Source__c = 'Olympus',                                                       // Source
            Customer_Site__c = 'Site-A',                                                 // Customer Site
            Note_NPD__c = 'MA_KTMTW0259_01E' ,                            // Note NPD
            Final_Review_Selection__c = false,                                           // Final Review Selection
                   // Unique_Id_Tower_Candidate__c = presurvey.id+'Site-A',  // Unique Id Tower Candidate
            IsSent__c = false                                                           // IsSent
            );

            Tower_Candidate__c towerANpdNoteNull = new Tower_Candidate__c(
            Candidate_Number__c = 1,                                                 // Candidate Number
            Presurvey__c = presurvey.id,                                                  // Presurvey
            Tower_ID__c = 'MA_KTMTW0259_01E',                                             // Tower ID
            Province__c = 'Kalimantan Tengah',                                           // Province
            Name = 'KAL-KT-MTW-0259-Site-A',                                             // Candidate Tower Name
            Kabupaten__c = 'Kab. Barito Utara',                                          // Kabupaten
            Router_ID__c ='MA_KTMTW0259_01E' ,                                           // Router ID
            Kecamatan__c = 'Kec. Teweh Tengah',                                          // Kecamatan
            Air_Distance__c = 150624432,                                             // Air Distance
            Fiber_Distance__c = 27781260,                                            // Fiber Distance
            Select_For_Assessment__c = True,
            IP_Loopback__c='MA_KTMTW0259_01E',                                            // Select for Assessment
            Source__c = 'Olympus',                                                       // Source
            Customer_Site__c = 'Site-A',                                                 // Customer Site
            Note_NPD__c = Null,                            // Note NPD
            Final_Review_Selection__c = false,                                           // Final Review Selection
                   // Unique_Id_Tower_Candidate__c = presurvey.id+'Site-A',  // Unique Id Tower Candidate
            IsSent__c = false                                                           // IsSent
            );

        towerCandidateList.add(towerANpdNoteNull);
        towerCandidateList.add(towerAtRouterNUll);
        towerCandidateList.add(towerAtwrIdNUll);
        towerCandidateList.add(towerAipLoopBackNull); 
        towerCandidateList.add(towerB); 

        Insert towerCandidateList;
        presurvey.Presurvey_Status__c = 'Waiting Capacity Assessment';
        try {
           update presurvey;
           System.assert(false, 'DML operation should have thrown an exception');
        } catch (DmlException e) {
            System.assertEquals(1, e.getNumDml());
            //System.assertEquals('Cannot edit a Billing Request with Status \'Created\'', e.getDmlMessage(0));
        }

        // Test Case 1 


         // Test Case 2
         Presurvey__c presurvey2 = new Presurvey__c(
            Customer_Name__c = generateRandomString(15),
            OwnerId = usr.id,
            Capacity__c = 10,
            UoM_Capacity__c = 'Mbps',
            Presurvey_Status__c = 'Draft',
            Customer_Requirement__c = 'For Test Purposed Only.\nSingleRecord',
            Service_Group__c = 'NON GSM',
            Service__c = 'MPLS',
            Province_Site_A__c = 'Sumatera Selatan',
            City_Site_A__c = 'Kabupaten Musi Banyuasin',
            Coordinate_Site_A__Latitude__s=0,
            Coordinate_Site_A__Longitude__s=113.867569,
            Coordinate_Site_B__Latitude__s=0,
            Need_Tower_Candidate_Site_B__c=True,
            Need_Tower_Candidate_Site_A__c=False,
            Coordinate_Site_B__Longitude__s=113.867569,
            Location_Site_A__c = generateRandomString(40) 
            );  
            insert presurvey2;
    
             Tower_Candidate__c towerA2 = new Tower_Candidate__c(
             Candidate_Number__c = 1,                                                 // Candidate Number
             Presurvey__c = presurvey2.id,                                                  // Presurvey
             Tower_ID__c = 'KAL-KT-MTW-0259',                                             // Tower ID
             Province__c = 'Kalimantan Tengah',                                           // Province
             Name = 'KAL-KT-MTW-0259-Site-A',                                             // Candidate Tower Name
             Kabupaten__c = 'Kab. Barito Utara',                                          // Kabupaten
             Router_ID__c = '12MA_KTMTW0259_01E',                                           // Router ID
             Kecamatan__c = 'Kec. Teweh Tengah',                                          // Kecamatan
             Air_Distance__c = 150624432,                                             // Air Distance
             Fiber_Distance__c = 27781260,                                            // Fiber Distance
             Select_For_Assessment__c = True, 
             IP_Loopback__c='',                                             // Select for Assessment
             Source__c = 'Olympus',                                                       // Source
             Customer_Site__c = 'Site-A',                                                 // Customer Site
             Note_NPD__c = 'Need confirm capacity CSR & Port',                            // Note NPD
             Final_Review_Selection__c = false,                                           // Final Review Selection
            //Unique_Id_Tower_Candidate__c = presurvey.id+'Site-B',  // Unique Id Tower Candidate
             IsSent__c = false                                                           // IsSent
             );
    
            Tower_Candidate__c towerBtwrIdNUll2 = new Tower_Candidate__c(
            Candidate_Number__c = 1,                                                 // Candidate Number
            Presurvey__c = presurvey2.id,                                                  // Presurvey
            Tower_ID__c = null,                                             // Tower ID
            Province__c = 'Kalimantan Tengah',                                           // Province
            Name = 'KAL-KT-MTW-0259-Site-B',                                             // Candidate Tower Name
            Kabupaten__c = '33Kab. Barito Utara',                                          // Kabupaten
            Router_ID__c = '33MA_KTMTW0259_01E',                                           // Router ID
            Kecamatan__c = '33Kec. Teweh Tengah',                                          // Kecamatan
            Air_Distance__c = 150624432,                                             // Air Distance
            Fiber_Distance__c = 27781260,                                            // Fiber Distance
            Select_For_Assessment__c = True,
            IP_Loopback__c= 'MA_KTMTW0259_01E',                                            // Select for Assessment
            Source__c = 'Olympus',                                                       // Source
            Customer_Site__c = 'Site-B',                                                 // Customer Site
            Note_NPD__c = 'MA_KTMTW0259_01E' ,                            // Note NPD
            Final_Review_Selection__c = false,                                           // Final Review Selection
                   // Unique_Id_Tower_Candidate__c = presurvey.id+'Site-A',  // Unique Id Tower Candidate
            IsSent__c = false                                                           // IsSent
            );
    
            Tower_Candidate__c towerBtRouterNUll2 = new Tower_Candidate__c(
                Candidate_Number__c = 1,                                                 // Candidate Number
                Presurvey__c = presurvey2.id,                                                  // Presurvey
                Tower_ID__c = '333MA_KTMTW0259_01E',                                             // Tower ID
                Province__c = '33Kalimantan Tengah',                                           // Province
                Name = 'KAL-KT-MTW-0259-Site-B',                                             // Candidate Tower Name
                Kabupaten__c = 'Kab. Barito Utara',                                          // Kabupaten
                Router_ID__c = Null,                                           // Router ID
                Kecamatan__c = 'Kec. Teweh Tengah',                                          // Kecamatan
                Air_Distance__c = 150624432,                                             // Air Distance
                Fiber_Distance__c = 27781260,                                            // Fiber Distance
                Select_For_Assessment__c = True,
                IP_Loopback__c= '33MA_KTMTW0259_01E',                                            // Select for Assessment
                Source__c = 'Olympus',                                                       // Source
                Customer_Site__c = 'Site-B',                                                 // Customer Site
                Note_NPD__c = '33MA_KTMTW0259_01E' ,                            // Note NPD
                Final_Review_Selection__c = false,                                           // Final Review Selection
                       // Unique_Id_Tower_Candidate__c = presurvey.id+'Site-A',  // Unique Id Tower Candidate
                IsSent__c = false                                                           // IsSent
                );
    
                Tower_Candidate__c towerBipLoopBackNull2 = new Tower_Candidate__c(
                Candidate_Number__c = 1,                                                 // Candidate Number
                Presurvey__c = presurvey2.id,                                                  // Presurvey
                Tower_ID__c = '233MA_KTMTW0259_01E',                                             // Tower ID
                Province__c = 'Kalimantan Tengah',                                           // Province
                Name = '33KAL-KT-MTW-0259-Site-B',                                             // Candidate Tower Name
                Kabupaten__c = 'Kab. Barito Utara',                                          // Kabupaten
                Router_ID__c ='33MA_KTMTW0259_01E' ,                                           // Router ID
                Kecamatan__c = 'Kec. Teweh Tengah',                                          // Kecamatan
                Air_Distance__c = 150624432,                                             // Air Distance
                Fiber_Distance__c = 27781260,                                            // Fiber Distance
                Select_For_Assessment__c = True,
                IP_Loopback__c= Null,                                            // Select for Assessment
                Source__c = 'Olympus',                                                       // Source
                Customer_Site__c = 'Site-B',                                                 // Customer Site
                Note_NPD__c = '33MA_KTMTW0259_01E' ,                            // Note NPD
                Final_Review_Selection__c = false,                                           // Final Review Selection
                       // Unique_Id_Tower_Candidate__c = presurvey.id+'Site-A',  // Unique Id Tower Candidate
                IsSent__c = false                                                           // IsSent
                );
    
                Tower_Candidate__c towerBNpdNoteNull2 = new Tower_Candidate__c(
                Candidate_Number__c = 1,                                                 // Candidate Number
                Presurvey__c = presurvey2.id,                                                  // Presurvey
                Tower_ID__c = '33MA_KTMTW0259_01E',                                             // Tower ID
                Province__c = 'Kalimantan Tengah',                                           // Province
                Name = 'KAL-KT-MTW-0259-Site-A',                                             // Candidate Tower Name
                Kabupaten__c = 'Kab. Barito Utara',                                          // Kabupaten
                Router_ID__c ='33MA_KTMTW0259_01E' ,                                           // Router ID
                Kecamatan__c = 'Kec. Teweh Tengah',                                          // Kecamatan
                Air_Distance__c = 150624432,                                             // Air Distance
                Fiber_Distance__c = 27781260,                                            // Fiber Distance
                Select_For_Assessment__c = True,
                IP_Loopback__c='33MA_KTMTW0259_01E',                                            // Select for Assessment
                Source__c = 'Olympus',                                                       // Source
                Customer_Site__c = 'Site-B',                                                 // Customer Site
                Note_NPD__c = Null,                            // Note NPD
                Final_Review_Selection__c = false,                                           // Final Review Selection
                       // Unique_Id_Tower_Candidate__c = presurvey.id+'Site-A',  // Unique Id Tower Candidate
                IsSent__c = false                                                           // IsSent
                );
    
            towerCandidateList2.add(towerBNpdNoteNull2);
            towerCandidateList2.add(towerBtRouterNUll2);
            towerCandidateList2.add(towerBtwrIdNUll2);
            towerCandidateList2.add(towerBipLoopBackNull2); 
            towerCandidateList2.add(towerA2); 
    
            Insert towerCandidateList2;
            presurvey2.Presurvey_Status__c = 'Waiting Capacity Assessment';
            try {
               update presurvey2;
               System.assert(false, 'DML operation should have thrown an exception');
            } catch (DmlException e) {
                System.assertEquals(1, e.getNumDml());
                //System.assertEquals('Cannot edit a Billing Request with Status \'Created\'', e.getDmlMessage(0));
            }
    
            // Test Case 2====================================


               //Test Case 3 ======================================================================

            Presurvey__c presurvey3 = new Presurvey__c(
            Customer_Name__c = generateRandomString(15),
            OwnerId = usr.id,
            Capacity__c = 10,
            UoM_Capacity__c = 'Mbps',
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
            Need_Tower_Candidate_Site_B__c=True,
            Coordinate_Site_B__Longitude__s=113.867569,
            Location_Site_A__c = generateRandomString(40) 
            );  
            insert presurvey3;
    
             Tower_Candidate__c towerB3 = new Tower_Candidate__c(
             Candidate_Number__c = 1,                                                 // Candidate Number
             Presurvey__c = presurvey3.id,                                                  // Presurvey
             Tower_ID__c = '28733KAL-KT-MTW-0259',                                             // Tower ID
             Province__c = 'Kalimantan Tengah',                                           // Province
             Name = '31434KAL-KT-MTW-0259-Site-B',                                             // Candidate Tower Name
             Kabupaten__c = 'Kab. Barito Utara',                                          // Kabupaten
             Router_ID__c = '287383MA_KTMTW0259_01E',                                           // Router ID
             Kecamatan__c = 'Kec. Teweh Tengah',                                          // Kecamatan
             Air_Distance__c = 150624432,                                             // Air Distance
             Fiber_Distance__c = 27781260,                                            // Fiber Distance
             Select_For_Assessment__c = True, 
             IP_Loopback__c='',                                             // Select for Assessment
             Source__c = 'Olympus',                                                       // Source
             Customer_Site__c = 'Site-B',                                                 // Customer Site
             Note_NPD__c = 'Need confirm capacity CSR & Port',                            // Note NPD
             Final_Review_Selection__c = false,                                           // Final Review Selection
            //Unique_Id_Tower_Candidate__c = presurvey.id+'Site-B',  // Unique Id Tower Candidate
             IsSent__c = false                                                           // IsSent
             );
    
            Tower_Candidate__c towerAtwrIdNUll3 = new Tower_Candidate__c(
            Candidate_Number__c = 1,                                                 // Candidate Number
            Presurvey__c = presurvey3.id,                                                  // Presurvey
            Tower_ID__c = null,                                             // Tower ID
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
    
            Tower_Candidate__c towerAtRouterNUll3 = new Tower_Candidate__c(
                Candidate_Number__c = 1,                                                 // Candidate Number
                Presurvey__c = presurvey3.id,                                                  // Presurvey
                Tower_ID__c = 'MA_KTMTW0259_01E',                                             // Tower ID
                Province__c = 'Kalimantan Tengah',                                           // Province
                Name = 'KAL-KT-MTW-0259-Site-A',                                             // Candidate Tower Name
                Kabupaten__c = 'Kab. Barito Utara',                                          // Kabupaten
                Router_ID__c = Null,                                           // Router ID
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
    
                Tower_Candidate__c towerAipLoopBackNull3 = new Tower_Candidate__c(
                Candidate_Number__c = 1,                                                 // Candidate Number
                Presurvey__c = presurvey3.id,                                                  // Presurvey
                Tower_ID__c = 'MA_KTMTW0259_01E',                                             // Tower ID
                Province__c = 'Kalimantan Tengah',                                           // Province
                Name = 'KAL-KT-MTW-0259-Site-A',                                             // Candidate Tower Name
                Kabupaten__c = 'Kab. Barito Utara',                                          // Kabupaten
                Router_ID__c ='MA_KTMTW0259_01E' ,                                           // Router ID
                Kecamatan__c = 'Kec. Teweh Tengah',                                          // Kecamatan
                Air_Distance__c = 150624432,                                             // Air Distance
                Fiber_Distance__c = 27781260,                                            // Fiber Distance
                Select_For_Assessment__c = True,
                IP_Loopback__c= Null,                                            // Select for Assessment
                Source__c = 'Olympus',                                                       // Source
                Customer_Site__c = 'Site-A',                                                 // Customer Site
                Note_NPD__c = 'MA_KTMTW0259_01E' ,                            // Note NPD
                Final_Review_Selection__c = false,                                           // Final Review Selection
                       // Unique_Id_Tower_Candidate__c = presurvey.id+'Site-A',  // Unique Id Tower Candidate
                IsSent__c = false                                                           // IsSent
                );
    
                Tower_Candidate__c towerANpdNoteNull3 = new Tower_Candidate__c(
                Candidate_Number__c = 1,                                                 // Candidate Number
                Presurvey__c = presurvey3.id,                                                  // Presurvey
                Tower_ID__c = '454MA_KTMTW0259_01E',                                             // Tower ID
                Province__c = 'Kalimantan Tengah',                                           // Province
                Name = '2313KAL-KT-MTW-0259-Site-A',                                             // Candidate Tower Name
                Kabupaten__c = 'Kab. Barito Utara',                                          // Kabupaten
                Router_ID__c ='343MA_KTMTW0259_01E' ,                                           // Router ID
                Kecamatan__c = 'Kec. Teweh Tengah',                                          // Kecamatan
                Air_Distance__c = 150624432,                                             // Air Distance
                Fiber_Distance__c = 27781260,                                            // Fiber Distance
                Select_For_Assessment__c = True,
                IP_Loopback__c='564MA_KTMTW0259_01E',                                            // Select for Assessment
                Source__c = 'Olympus',                                                       // Source
                Customer_Site__c = 'Site-A',                                                 // Customer Site
                Note_NPD__c = Null,                            // Note NPD
                Final_Review_Selection__c = false,                                           // Final Review Selection
                       // Unique_Id_Tower_Candidate__c = presurvey.id+'Site-A',  // Unique Id Tower Candidate
                IsSent__c = false                                                           // IsSent
                );
    
            towerCandidateList3.add(towerANpdNoteNull3);
            towerCandidateList3.add(towerAtRouterNUll3);
            towerCandidateList3.add(towerAtwrIdNUll3);
            towerCandidateList3.add(towerAipLoopBackNull3); 
            towerCandidateList3.add(towerB3); 
    
            Insert towerCandidateList3;
            presurvey3.Presurvey_Status__c = 'Waiting Capacity Assessment';
            try {
               update presurvey3;
               System.assert(false, 'DML operation should have thrown an exception');
            } catch (DmlException e) {
                System.assertEquals(1, e.getNumDml());
                //System.assertEquals('Cannot edit a Billing Request with Status \'Created\'', e.getDmlMessage(0));
            }
    
            // Test Case 3 ====================================================================
          

      
}


    
}