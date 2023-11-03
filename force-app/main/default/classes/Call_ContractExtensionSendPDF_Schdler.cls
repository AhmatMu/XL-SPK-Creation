global class Call_ContractExtensionSendPDF_Schdler implements Schedulable{
    Public String recordId;

    global Call_ContractExtensionSendPDF_Schdler(String arecordId) {
        if ( recordId == null ) {
            recordId = arecordId;
        }
    }
    
    global void execute(SchedulableContext sc){
        testScheduleClassMethod(recordId);
    }

    global void testScheduleClassMethod(String argPass){
        if(!Test.isRunningTest()){
            Button_Emaill_SendBACustomer_Ctrl.SendEmailActionTrigger(argPass);
        }
    }
}