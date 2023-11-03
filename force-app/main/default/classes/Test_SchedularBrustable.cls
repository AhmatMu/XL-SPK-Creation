@isTest 
Private Class Test_SchedularBrustable{ 
 
 @isTest 
 static void testMethodSchedule(){ 
      Test.startTest(); 
      String cronExp ='0 48 * * * ?'; 
      System.schedule('JobName', cronExp, new Schedule_CreateBurstableContracts()); 
      Test.stopTest(); 
 } 
 
}