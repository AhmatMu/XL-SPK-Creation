@isTest (seealldata=true)
private class Test_HitUpdatePRStatus {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new Mock_HitUpdatePRStatus());
        
        //Opportunity OP=[SELECT id, PR__c,PR_Status__c,StageName,Opportunity_ID__c FROM Opportunity WHERE ID='0065D0000048Jpo']; //Data Sandbox
        Opportunity OP=[SELECT id, PR__c,PR_Status__c,StageName,Opportunity_ID__c FROM Opportunity WHERE ID='0067F000008jeC5']; //Data Production
        
        system.debug('oppty idnya :'+op.Id);
        hitupdatePRStatus.updatePRStatus(Op.id);
        
        test.stopTest();
          
    }
    static testMethod void myUnitTest2() {
        test.startTest();
        Test.setMock(WebServiceMock.class, new Mock_HitUpdatePRStatus());
        //Opportunity OP=[SELECT id, PR__c,PR_Status__c,StageName,Opportunity_ID__c FROM Opportunity WHERE ID='0065D0000048Jpo']; //Data Sandbox
        Opportunity OP2=[SELECT id, PR__c,PR_Status__c,StageName,Opportunity_ID__c FROM Opportunity WHERE ID='0067F000008jeC5']; //Data Production
        
        hitupdatePRStatus.updatePRStatus(Op2.pr__c);
        
        test.stopTest();  
    }
}