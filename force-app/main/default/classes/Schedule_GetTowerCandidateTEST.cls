@isTest
private class Schedule_GetTowerCandidateTEST {
    @isTest
    static void testRunningSchedule(){
        Test.startTest();

        
        String cronExp = '0 0 0 * * ?'; // Daily at midnight (GMT)

        System.schedule('Test_Schedule_GetTowerCandidate', cronExp, new Schedule_GetTowerCandidate());

        Test.stopTest();
    }
}