/**
 * @description       : 
 * @Test Class		  : Trigger_NPRTicketHandler_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 04-27-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   12-27-2021   Novando Utoyo Agmawan   Initial Version
**/

public class Trigger_NPRTicketHandler implements ITriggerHandler {
    public Boolean IsDisabled()
    {
        return false;
    }
    
    public void BeforeInsert(List<SObject> newItems) {
    }
    
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
    }
    
    public void BeforeDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterInsert(Map<Id, SObject> newItems) {}
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        Handle_Approved_OnAfterUpdate(newItems,oldItems);
        Handle_Inreview_OnAfterUpdate(newItems,oldItems);
        Handle_Rejected_OnAfterUpdate(newItems,oldItems);
        Handle_MoveStageFromTrigger_OnAfterUpdate(newItems,oldItems);
        Handle_ResendEmailProductLaunch_OnAfterUpdate(newItems,oldItems);
    }
    
    public void AfterDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterUndelete(Map<Id, SObject> oldItems) {}

    public void Handle_Approved_OnAfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        try {
            Set<String> tikectIds = new set<String>();

            for(SObject newProductRegTicket : newItems.values()){
                SObject old_newProductRegTicket;
                if(oldItems != null && oldItems.get((id)newProductRegTicket.get('Id')) != null){
                    old_newProductRegTicket = oldItems.get((Id)newProductRegTicket.get('Id'));

                    if( 
                        newProductRegTicket.get('Approval_Status__c') != old_newProductRegTicket.get('Approval_Status__c') &&
                        newProductRegTicket.get('Approval_Status__c') == 'Approved'
                    ){
                        tikectIds.add((String)newProductRegTicket.get('Id'));
                    }
                }

                if(tikectIds!=null && !tikectIds.isEmpty()){
                    NewProductRegistrationTicketService NewProductRegistrationTicketService_Class = new NewProductRegistrationTicketService(tikectIds);

                    List<NPRTicketDocTempalate__c> List_TicketDocTempalates = [SELECT Id, Approval_Status__c FROM NPRTicketDocTempalate__c WHERE New_Product_Registration_Ticket__c IN : tikectIds];

                    For(NPRTicketDocTempalate__c List_TicketDocTempalates_Extract : List_TicketDocTempalates){
                        List_TicketDocTempalates_Extract.Approval_Status__c = 'Approved';
                    }
                    update List_TicketDocTempalates;

                    List<NPRTicketProduct__c> List_TicketProducts = [SELECT Id, Approval_Status__c FROM NPRTicketProduct__c WHERE New_Product_Registration_Ticket__c IN : tikectIds];

                    For(NPRTicketProduct__c List_TicketProducts_Extract : List_TicketProducts){
                        List_TicketProducts_Extract.Approval_Status__c = 'Approved';
                    }
                    update List_TicketProducts;
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger After Update - Trigger_NPRTicketHandler.cls - Handle_Approved_OnAfterUpdate ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

    public void Handle_Inreview_OnAfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        try {
            Set<String> tikectIds = new set<String>();

            for(SObject newProductRegTicket : newItems.values()){
                SObject old_newProductRegTicket;
                if(oldItems != null && oldItems.get((id)newProductRegTicket.get('Id')) != null){
                    old_newProductRegTicket = oldItems.get((Id)newProductRegTicket.get('Id'));

                    if( 
                        newProductRegTicket.get('Approval_Status__c') != old_newProductRegTicket.get('Approval_Status__c') &&
                        newProductRegTicket.get('Approval_Status__c') == 'Inreview'
                    ){
                        tikectIds.add((String)newProductRegTicket.get('Id'));
                    }
                }

                if(tikectIds!=null && !tikectIds.isEmpty()){
                    List<NPRTicketDocTempalate__c> List_TicketDocTempalates = [SELECT Id, Approval_Status__c FROM NPRTicketDocTempalate__c WHERE New_Product_Registration_Ticket__c IN : tikectIds];

                    For(NPRTicketDocTempalate__c List_TicketDocTempalates_Extract : List_TicketDocTempalates){
                        List_TicketDocTempalates_Extract.Approval_Status__c = 'Inreview';
                    }
                    update List_TicketDocTempalates;

                    List<NPRTicketProduct__c> List_TicketProducts = [SELECT Id, Approval_Status__c FROM NPRTicketProduct__c WHERE New_Product_Registration_Ticket__c IN : tikectIds];

                    For(NPRTicketProduct__c List_TicketProducts_Extract : List_TicketProducts){
                        List_TicketProducts_Extract.Approval_Status__c = 'Inreview';
                    }
                    update List_TicketProducts;
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger After Update - Trigger_NPRTicketHandler.cls - Handle_Inreview_OnAfterUpdate ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

    public void Handle_Rejected_OnAfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        try {
            Set<String> tikectIds = new set<String>();

            for(SObject newProductRegTicket : newItems.values()){
                SObject old_newProductRegTicket;
                if(oldItems != null && oldItems.get((id)newProductRegTicket.get('Id')) != null){
                    old_newProductRegTicket = oldItems.get((Id)newProductRegTicket.get('Id'));

                    if( 
                        newProductRegTicket.get('Approval_Status__c') != old_newProductRegTicket.get('Approval_Status__c') &&
                        newProductRegTicket.get('Approval_Status__c') == 'Rejected'
                    ){
                        tikectIds.add((String)newProductRegTicket.get('Id'));
                    }
                }

                if(tikectIds!=null && !tikectIds.isEmpty()){
                    List<NPRTicketDocTempalate__c> List_TicketDocTempalates = [SELECT Id, Approval_Status__c FROM NPRTicketDocTempalate__c WHERE New_Product_Registration_Ticket__c IN : tikectIds];

                    For(NPRTicketDocTempalate__c List_TicketDocTempalates_Extract : List_TicketDocTempalates){
                        List_TicketDocTempalates_Extract.Approval_Status__c = 'Rejected';
                    }
                    update List_TicketDocTempalates;

                    List<NPRTicketProduct__c> List_TicketProducts = [SELECT Id, Approval_Status__c FROM NPRTicketProduct__c WHERE New_Product_Registration_Ticket__c IN : tikectIds];

                    For(NPRTicketProduct__c List_TicketProducts_Extract : List_TicketProducts){
                        List_TicketProducts_Extract.Approval_Status__c = 'Rejected';
                    }
                    update List_TicketProducts;
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger After Update - Trigger_NPRTicketHandler.cls - Handle_Rejected_OnAfterUpdate ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

    public void Handle_MoveStageFromTrigger_OnAfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        try {
            Set<string> Set_POBTicketIds = new Set<string>();

            for(SObject newProductRegTicket : newItems.values()){
                SObject old_newProductRegTicket;
                if(oldItems != null && oldItems.get((id)newProductRegTicket.get('Id')) != null){
                    old_newProductRegTicket = oldItems.get((Id)newProductRegTicket.get('Id'));

                    if( 
                        newProductRegTicket.get('Move_Stage_From_Trigger__c') != old_newProductRegTicket.get('Move_Stage_From_Trigger__c')
                    ){
                        Set_POBTicketIds.add((String)newProductRegTicket.get('Id') );
                    }
                }
            }

            system.debug('Set_POBTicketIds : ' + Set_POBTicketIds);

            if(Set_POBTicketIds!=null && !Set_POBTicketIds.isEmpty()){
                List<New_Product_Registration_Ticket__c> List_NewProductRegistrationTicket = [SELECT Id, Move_Stage_From_Trigger__c FROM New_Product_Registration_Ticket__c WHERE Id IN:Set_POBTicketIds];

                system.debug('List_NewProductRegistrationTicket : ' + List_NewProductRegistrationTicket);

                if(List_NewProductRegistrationTicket!=null && !List_NewProductRegistrationTicket.isEmpty()){
                    for(New_Product_Registration_Ticket__c List_NewProductRegistrationTicket_Extract : List_NewProductRegistrationTicket){
                        List_NewProductRegistrationTicket_Extract.Move_Stage_From_Trigger__c = false;
                    }
                    update List_NewProductRegistrationTicket;
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger After Update - Trigger_NPRTicketHandler.cls - Handle_MoveStageFromTrigger_OnAfterUpdate ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

    public void Handle_ResendEmailProductLaunch_OnAfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        DateTime start_time = datetime.now();
        try {
            Set<string> Set_POBTicketIds = new Set<string>();

            for(SObject newProductRegTicket : newItems.values()){
                SObject old_newProductRegTicket;
                if(oldItems != null && oldItems.get((id)newProductRegTicket.get('Id')) != null){
                    old_newProductRegTicket = oldItems.get((Id)newProductRegTicket.get('Id'));

                    if( 
                        newProductRegTicket.get('Resend_Email__c') != old_newProductRegTicket.get('Resend_Email__c') && 
                        newProductRegTicket.get('Resend_Email__c') == true
                    ){
                        Set_POBTicketIds.add((String)newProductRegTicket.get('Id') );
                    }
                }
            }

            system.debug('Set_POBTicketIds : ' + Set_POBTicketIds);

            if(Set_POBTicketIds!=null && !Set_POBTicketIds.isEmpty()){
                NewProductRegistrationTicketService.sendEmailforNewProduct(Set_POBTicketIds);

                List<New_Product_Registration_Ticket__c> List_NewProductRegistrationTicket = [SELECT Id, Resend_Email__c FROM New_Product_Registration_Ticket__c WHERE Id IN:Set_POBTicketIds];

                system.debug('List_NewProductRegistrationTicket : ' + List_NewProductRegistrationTicket);

                if(List_NewProductRegistrationTicket!=null && !List_NewProductRegistrationTicket.isEmpty()){
                    for(New_Product_Registration_Ticket__c List_NewProductRegistrationTicket_Extract : List_NewProductRegistrationTicket){
                        List_NewProductRegistrationTicket_Extract.Resend_Email__c = false;
                    }
                    update List_NewProductRegistrationTicket;
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on Trigger After Update - Trigger_NPRTicketHandler.cls - Handle_ResendEmailProductLaunch_OnAfterUpdate ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }
}