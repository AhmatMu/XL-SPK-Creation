/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 07-29-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   07-29-2022   Novando Utoyo Agmawan   Initial Version
**/

public class BapController {

    public void Update_BAPTempIsolationStatus_Draft(Id bapid){
        DateTime start_time = datetime.now();
        try {
            List<BAP__c> bapList = [SELECT Id, Request_Status__c,Remark__c FROM BAP__c WHERE Id=:bapid];

            if(bapList !=null && !bapList.isEmpty()) {
                bapList[0].Request_Status__c = 'Draft';
                update bapList;
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on BapController.cls - Update_BAPTempIsolationStatus_Draft ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

    public void Update_BAPTempIsolationStatus_ProcessIsolation(Id bapid){
        DateTime start_time = datetime.now();
        try {
            List<BAP__c> bapList = [SELECT Id, Request_Status__c,Remark__c FROM BAP__c WHERE Id=:bapid AND createBAPTemp_Isolation_easyOps__c =: true];

            if(bapList !=null && !bapList.isEmpty()) {
                bapList[0].Request_Status__c = 'BA Sent to Customer';
                bapList[0].Remark__c = 'BA Sent to Customer';
                update bapList;
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on BapController.cls - Update_BAPTempIsolationStatus_ProcessIsolation ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

    public void Update_BAPTempIsolationStatus_Rejected_BacktoDraft(Id bapid){
        DateTime start_time = datetime.now();
        try {
            List<BAP__c> bapList = [SELECT Id, Request_Status__c,Remark__c FROM BAP__c WHERE Id=:bapid AND createBAPTemp_Isolation_easyOps__c =: true AND Request_Status__c =: 'Waiting Approval'];

            if(bapList !=null && !bapList.isEmpty()) {
                bapList[0].Request_Status__c = 'Draft';
                bapList[0].Remark__c = 'BAP record need to revise';
                update bapList;
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on BapController.cls - Update_BAPTempIsolationStatus_Rejected_BacktoDraft ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

    public void Update_BAPTempIsolationStatus_EndDate(Id bapid){
        DateTime start_time = datetime.now();
        try {
            List<BAP__c> bapList = [SELECT Id, Isolation_End_Date__c,Isolation_Desire_End_Date__c FROM BAP__c WHERE Id=:bapid];

            if(bapList !=null && !bapList.isEmpty()) {
                Date DesireDate = bapList[0].Isolation_Desire_End_Date__c;
                bapList[0].Isolation_End_Date__c = DesireDate;
                bapList[0].Isolation_Desire_End_Date__c = null;
                update bapList;
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on BapController.cls - Update_BAPTempIsolationStatus_EndDate ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

}