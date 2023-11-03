@IsTest
private class ApprovalCommentsControllerTest {
	 @IsTest
    private static void test_get_comments() {

        ApprovalCommentController contr = new ApprovalCommentController();
        System.debug( contr.comments );

    }
}