/**
 * @description       : 
 * @author            : Ahmat Zulkifli Murad
 * @group             : 
 * @last modified on  : 08-01-2023
 * @last modified by  : Ahmat Zulkifli Murad
**/
@isTest
public with sharing class TA_AT_AutoSelectTowerinFinalReviewTEST {

    @isTest
    static void presurveyMovetoFinalReview(){
        list<Tower_Candidate__c> candidateTowerList = new list<Tower_Candidate__c>();

        Id recordTypeId_NonGSMLL = Schema.SObjectType.Presurvey__c.getRecordTypeInfosByName().get('NON GSM LL').getRecordTypeId();
        Presurvey__c presurveyRec = new Presurvey__c(
            RecordTypeId = recordTypeId_NonGSMLL,                                                                                    // Record Type
            Customer_Name__c = 'PT Manual Guide 2 SITES',                                                                    // Customer Name
            Capacity__c = 200,                                                                                             // Capacity
            Service_Group__c = 'NON GSM',                                                                                    // Service Group
            UoM_Capacity__c = 'Mbps',                                                                                        // UoM Capacity
            Service__c = 'LL',                                                                                            // Service
            Presurvey_Status__c = 'draft',      
            Coordinate_Site_A__Latitude__s = -7.56,
            Coordinate_Site_A__Longitude__s  = 110.807889,
            Coordinate_Site_B__Latitude__s  = -8.0625,
            Coordinate_Site_B__Longitude__s = 110.517167,                                                                      // Presurvey Status
            Update_Source__c = 'User',                                                                                       // Update Source
            In_Progress_Status__c = 'No Need to Request',                                                                    // In Progress Status
            Get_Tower_API_Call_Number__c = 0,                                                                              // Get Tower API Call Number
            Province_Site_A__c = 'Jawa Tengah',                                                                              // Province Site A
            Province_Site_B__c = 'Daerah Istimewa Yogyakarta',                                                               // Province Site B
            City_Site_A__c = 'Kota Surakarta',                                                                               // City Site A
            City_Site_B__c = 'Kabupaten Gunungkidul',                                                                        // City Site B
            Location_Site_A__c = 'Jl. Kolonel Sutarto No.16, Jebres, Kec. Jebres, Kota Surakarta, Jawa Tengah 57126',        // Location Site A
            Location_Site_B__c = 'Karang, Jetis, Kec. Saptosari, Kabupaten Gunung Kidul, Daerah Istimewa Yogyakarta 55871',  // Location Site B
            Need_Tower_Candidate_Site_A__c = false,                                                                          // Need Tower Candidate Site A ?
            Need_Tower_Candidate_Site_B__c = false,                                                                          // Need Tower Candidate Site B ?
            Waiting_Capacity_Assessment_Date__c = Date.newInstance(2023, 07, 07)                                            // Waiting Capacity Assessment Date
            //Final_Review_Date__c = Date.valueOf('8-1-2023')                                                                 // Final Review Date
        );
        insert presurveyRec;

        Tower_Candidate__c towerCandidate1 = new Tower_Candidate__c(
            Candidate_Number__c = 1,                                                 // Candidate Number
            Presurvey__c = presurveyRec.id,                                                  // Presurvey
            Tower_ID__c = 'JAW-JT-SKT-2066',                                             // Tower ID
            Province__c = 'Jawa Tengah',                                                 // Province
            Name = 'JAW-JT-SKT-2066-Site-A',                                             // Candidate Tower Name
            Kabupaten__c = 'Kota Surakarta',                                             // Kabupaten
            Router_ID__c = 'MA-SMB407-01H',                                              // Router ID
            Kecamatan__c = 'Kec. Banjarsari',                                            // Kecamatan
            Air_Distance__c = 321440,                                                 // Air Distance
            Coordinate__Latitude__s = -7.56,
            Coordinate__Longitude__s = 110.807889,  
            Fiber_Distance__c = 385,                                                // Fiber Distance
            Select_For_Assessment__c = false,                                            // Select for Assessment
            Source__c = 'Olympus',                                                       // Source
            IP_Loopback__c = '101010',                                                 // IP Loopback
            Customer_Site__c = 'Site-A',                                                 // Customer Site
            Note_NPD__c = 'Need confirm capacity CSR & Port',                            // Note NPD
            Final_Review_Selection__c = false,                                           // Final Review Selection
            Unique_Id_Tower_Candidate__c = 'a141m000001B0kMAAS_JAW-JT-SKT-2066_Site-A',  // Unique Id Tower Candidate
            IsSent__c = false                                                           // IsSent
        );
        insert towerCandidate1;

        Tower_Candidate__c towerCandidate2 = new Tower_Candidate__c(
            Candidate_Number__c = 1,                                                 // Candidate Number
            Presurvey__c = presurveyRec.id,                                                  // Presurvey
            Tower_ID__c = 'JAW-YO-WNO-0641',                                             // Tower ID
            Province__c = 'Yogyakarta (DIY)',                                            // Province
            Name = 'JAW-YO-WNO-0641-Site-B',                                             // Candidate Tower Name
            Kabupaten__c = 'Kab. Gunung Kidul',                                          // Kabupaten
            Router_ID__c = 'MA-YGWNO0641-01H~MA-YG3535521G-01H',                         // Router ID
            Kecamatan__c = 'Kec. Saptosari (Sapto Sari)',                                // Kecamatan
            Air_Distance__c = 3648468,                                               // Air Distance
            Coordinate__Latitude__s = -8.0625,
            Coordinate__Longitude__s = 110.517167,  
            Fiber_Distance__c = 5065,                                              // Fiber Distance
            Select_For_Assessment__c = false,                                            // Select for Assessment
            Source__c = 'Olympus',                                                       // Source
            IP_Loopback__c = '101010',                                                 // IP Loopback
            Customer_Site__c = 'Site-B',                                                 // Customer Site
            Note_NPD__c = 'Need confirm capacity CSR & Port',                            // Note NPD
            Final_Review_Selection__c = false,                                           // Final Review Selection
            Unique_Id_Tower_Candidate__c = 'a141m000001B0kMAAS_JAW-YO-WNO-0641_Site-B',  // Unique Id Tower Candidate
            IsSent__c = false                                                           // IsSent
        );
        insert towerCandidate2;

        candidateTowerList.add(towerCandidate1);
        candidateTowerList.add(towerCandidate2);

        

        MetadataTriggerHandler.bypass('TA_AT_PresurveyCalloutOlympus');
        presurveyRec.Presurvey_Status__c = 'In Progress';
        update presurveyRec;
        MetadataTriggerHandler.clearBypass('TA_AT_PresurveyCalloutOlympus');

        if(candidateTowerList != null){
            for(Tower_Candidate__c candidateTowerListRec :candidateTowerList){
                candidateTowerListRec.Select_For_Assessment__c = true;

                update candidateTowerListRec;
            }
        }

        presurveyRec.Presurvey_Status__c = 'Waiting Capacity Assessment';
        update presurveyRec;

        
        presurveyRec.Presurvey_Status__c = 'final review';
        update presurveyRec;
    }
}