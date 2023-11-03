@isTest
public class CmpApprovalURLController_Test {
    static testMethod void testMthod1() {
        Test.startTest();
            CmpApprovalURLController test22 = new CmpApprovalURLController();
            test22.objRecordID = '0017F00000RM9fyQAD';
            System.assertEquals(test22.urlStr , AppUtils.generateApprovalURL('0017F00000RM9fyQAD'));
        Test.stopTest();
    }
}