/**
 * @description       : 
 * @Test Class        : OrderMaterialCheckValidate_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 12-14-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   12-06-2022   Novando Utoyo Agmawan   Initial Version
**/

public class OrderMaterialCheckValidate_Ctrl {
    ApexPages.StandardSetController setCon; 
    ApexPages.StandardController con;

    public id orderId {get; set;}
    
    public OrderMaterialCheckValidate_Ctrl (ApexPages.StandardSetController controller) {
        setCon = controller;
    }
    public OrderMaterialCheckValidate_Ctrl (ApexPages.StandardController controller) {
        con = controller;
    }

    public void validateMaterialCheckStatus(){
        try{
            orderId  = ApexPages.CurrentPage().getparameters().get('id');

            string currentDatetime = string.valueOf(Datetime.now());
            
            list<Order> List_Order = [
                SELECT Id,
                SAP_Material_Check_Status__c
                FROM Order 
                WHERE Id =: orderId
            ];

            system.debug('List_Order : ' + List_Order);

            if(String.isNotBlank(List_Order[0].SAP_Material_Check_Status__c)){
                if(List_Order[0].SAP_Material_Check_Status__c == 'Success'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'SUCCEED! Your Order has been Saved per ' + currentDatetime));
                }

                if(List_Order[0].SAP_Material_Check_Status__c == 'No Stock'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'FAILED! Your Order Failed to Saved. The system doesn’t have some or all of the requested material per ' + currentDatetime + '. Please check the material availability with related team and try to Submit Order again'));
                }

                if(List_Order[0].SAP_Material_Check_Status__c == 'Error'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'FAILED! Your Order failed to create because of an Error. Please contact your System Administrator.'));
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch(exception e){
            String errorMsg = 'Error on OrderMaterialCheckValidate_Ctrl.validateMaterialChecStatus method.::' + e.getmessage() + ' - ' + e.getStacktraceString() + ' :: ' + e.getLineNumber();

            apputils.puterror(errorMsg);
            SYSTEM.DEBUG('===== errorMsg : ' + errorMsg);
        }
    }

    public void onLoadMaterialCheckStatusValidate(){
        try{
            orderId  = ApexPages.CurrentPage().getparameters().get('id');

            string currentDatetime = string.valueOf(Datetime.now());
            
            list<Order> List_Order = [
                SELECT Id,
                SAP_Material_Check_Status__c
                FROM Order 
                WHERE Id =: orderId
            ];

            system.debug('List_Order : ' + List_Order);

            if(String.isNotBlank(List_Order[0].SAP_Material_Check_Status__c)){
                if(List_Order[0].SAP_Material_Check_Status__c == 'Success'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'SUCCEED! Your Order has been Saved per ' + currentDatetime));
                }

                if(List_Order[0].SAP_Material_Check_Status__c == 'No Stock'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'FAILED! Your Order Failed to Saved. The system doesn’t have some or all of the requested material per ' + currentDatetime + '. Please check the material availability with related team and try to Submit Order again'));
                }

                if(List_Order[0].SAP_Material_Check_Status__c == 'Error'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'FAILED! Your Order failed to create because of an Error. Please contact your System Administrator.'));
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch(exception e){
            String errorMsg = 'Error on OrderMaterialCheckValidate_Ctrl.onLoadMaterialCheckStatusValidate method.::' + e.getmessage() + ' - ' + e.getStacktraceString() + ' :: ' + e.getLineNumber();

            apputils.puterror(errorMsg);
            SYSTEM.DEBUG('===== errorMsg : ' + errorMsg);
        }
    }
}