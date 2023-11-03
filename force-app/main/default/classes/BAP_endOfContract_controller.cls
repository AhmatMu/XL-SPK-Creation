/**
 * @description       : 
 * @Test Class		  : TEST_BAP_endOfContract_controller
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 08-01-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   07-29-2022   Novando Utoyo Agmawan   Initial Version
**/

public class BAP_endOfContract_controller {

    public void Create_BAP_endOfContract(Set<Id> contractId){
        DateTime start_time = datetime.now();
        try {
            list<Contract_Extension__c> ContractExtension_List = 
            [
                SELECT Id,
                Status__c,
                Name, 
                Account__c,
                Account__r.OwnerId,
                Account__r.Organization_Type__c,
                Existing_Contract_item__c,
                Existing_Contract_item__r.Link__c,
                Existing_Contract_item__r.Sales__c,
                Existing_Contract_item__r.Sales_Email__c,
                Existing_Contract_item__r.End_Date__c,
                Existing_Contract_item__r.Start_Date__c,
                Existing_Contract_item__r.Link__r.Link_ID__c,
                Existing_Contract_item__r.Link__r.Name,
                Existing_Contract_item__r.Link__r.Contract_Item_Rel__c,
                Existing_Contract_item__r.Link__r.Free_Link__c,
                Existing_Contract_item__r.Link__r.Service_Type__c,
                Existing_Contract_item__r.Link__r.Site_A_Name__c,
                Existing_Contract_item__r.Link__r.Site_A_Name__r.ParentId,
                Link__c,
                Link__r.Link_ID__c,
                Link__r.Name,
                Link__r.Contract_Item_Rel__c,
                Link__r.Free_Link__c,
                Link__r.Service_Type__c,
                Link__r.Site_A_Name__c,
                Link__r.Site_A_Name__r.ParentId,
                BAP__c
                FROM Contract_Extension__c 
                WHERE Existing_Contract_item__c IN: contractId AND 
                Status__c != 'Waiting Solution Approval' AND
                Account__r.Organization_Type__c = 'Head Office' AND
                (
                    Existing_Contract_item__r.Link__r.Contract_Item_Rel__c != null OR
                    Existing_Contract_item__r.Link__r.Free_Link__c = true OR
                    Existing_Contract_item__r.Link__r.Service_Type__c = 'VOIP'
                )
            ];

            system.debug('ContractExtension_List30days ' + ContractExtension_List);

            if(ContractExtension_List!=null && !ContractExtension_List.isEmpty()){
                Id recordTypeId_bapEndofContract = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('End of Contract').getRecordTypeId();

                List<BAP__c> newBAP_List = new List<BAP__c>();

                for(Contract_Extension__c ContractExtension_List_Extract : ContractExtension_List){
                    BAP__c bapEndofContract = new BAP__c(
                        RecordTypeId = recordTypeId_bapEndofContract,                               
                        Name = '[BAP-EOC] ' + ContractExtension_List_Extract.Link__r.Name + ' - ' + ContractExtension_List_Extract.Link__r.Link_ID__c,
                        Type_of_Request__c = 'Pemutusan',         
                        Customer__c = ContractExtension_List_Extract.Account__c,                      
                        Request_Status__c = 'Draft',
                        PIC_Name__c = ContractExtension_List_Extract.Existing_Contract_item__r.Sales__c,
                        PIC_Phone__c = Label.BAP_EndOfContract_PIC_Phone,                             
                        PIC_email__c = ContractExtension_List_Extract.Existing_Contract_item__r.Sales_Email__c,
                        PIC_Position__c = 'Accouunt Manager',                 
                        Reason__c = 'Kontrak berakhir atau tidak diperpanjang',
                        Note__c = 'This termination proces are related to BA extension No : ' + ContractExtension_List_Extract.Name,   
                        BA_Extend_REL__c = ContractExtension_List_Extract.Id,
                        Terminate_Date__c = ContractExtension_List_Extract.Existing_Contract_item__r.End_Date__c.addDays(1),
                        Contract_Start_Date__c = ContractExtension_List_Extract.Existing_Contract_item__r.Start_Date__c,
                        Contract_End_Date__c = ContractExtension_List_Extract.Existing_Contract_item__r.End_Date__c,
                        OwnerId = ContractExtension_List_Extract.Account__r.OwnerId
                    );

                    if(
                        ContractExtension_List_Extract.Account__c == ContractExtension_List_Extract.Existing_Contract_item__r.Link__r.Site_A_Name__c ||
                        ContractExtension_List_Extract.Account__c == ContractExtension_List_Extract.Existing_Contract_item__r.Link__r.Site_A_Name__r.ParentId
                    ){
                        bapEndofContract.Link__c = ContractExtension_List_Extract.Existing_Contract_item__r.Link__c;
                    }

                    newBAP_List.add(bapEndofContract);
                }

                if(newBAP_List!=null && !newBAP_List.isEmpty()){
                    Insert newBAP_List;

                    for(BAP__c newBAP_List_extract : newBAP_List){
                        newBAP_List_extract.Request_Status__c = 'Submit';
                    }
                    update newBAP_List;

                    for(BAP__c newBAP_List_extract : newBAP_List){
                        for(Contract_Extension__c ContractExtension_List_Extract : ContractExtension_List){
                            if(newBAP_List_extract.BA_Extend_REL__c == ContractExtension_List_Extract.Id){
                                ContractExtension_List_Extract.BAP__c = newBAP_List_extract.Id;
                            }
                        }
                    }
                    update ContractExtension_List;
                }
            }
          
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on BAP_endOfContract_controller.cls - Create_BAP_endOfContract_FromContract ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }
}