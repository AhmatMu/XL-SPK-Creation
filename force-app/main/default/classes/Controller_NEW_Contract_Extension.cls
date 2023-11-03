/**
 * @description       : 
 * @Test Class        : TEST_Notif_Contract_Extension
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 01-19-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   11-09-2021   Novando Utoyo Agmawan   Initial Version
**/

public class Controller_NEW_Contract_Extension {
    public List<Contract> All_Contract_List {get; set;}

    public List<Contract_Extension__c> All_ContractExtension_NEW_List {get; set;}
    public List<Contract_Extension__c> All_ContractExtension_Criteria_Complete_List {get; set;}
    public List<Contract_Extension__c> All_ContractExtension_Criteria_NotComplete_List {get; set;}

    public List<AccountContactRelation> All_Contact_Information_List {get; set;}

    public Controller_NEW_Contract_Extension(List<Contract> FetchAll_Contract_List){
        DateTime start_time = datetime.now();
        All_Contract_List = FetchAll_Contract_List;

        try {
            if(All_Contract_List!=null && !All_Contract_List.isEmpty()){
                Set<Id> All_ContractExtensionIds = new Set<Id>();
                Set<Id> All_accIds = new Set<Id>();
                Set<Id> All_accIds_Criteria_Complete = new Set<Id>();

                All_ContractExtension_NEW_List = new List<Contract_Extension__c>();
                All_ContractExtension_Criteria_Complete_List = new List<Contract_Extension__c>();
                All_ContractExtension_Criteria_NotComplete_List = new List<Contract_Extension__c>();

                Date extensionStartDate;
                Integer contractTerm;
                String contractPeriode;
                Date extensionEndDate;

                for(Contract All_Contract_List_Extract : All_Contract_List){
                    extensionStartDate = All_Contract_List_Extract.End_Date__c.addDays(1);

                    contractTerm = Integer.ValueOf(All_Contract_List_Extract.Contract_Term__c);
                    contractPeriode = All_Contract_List_Extract.Periode_UOM__c;

                    if(contractPeriode == 'Month'){
                        extensionEndDate = All_Contract_List_Extract.End_Date__c.addMonths(contractTerm);
                    }else if(contractPeriode == 'Week'){
                        extensionEndDate = All_Contract_List_Extract.End_Date__c.addDays(contractTerm*7);
                    }else if(contractPeriode == 'Day'){
                        extensionEndDate = All_Contract_List_Extract.End_Date__c.addDays(contractTerm);
                    }

                    Contract_Extension__c contractExtensionOBJ = new Contract_Extension__c();
                    contractExtensionOBJ.Name = 'BA Extension ' + All_Contract_List_Extract.Account.Name +'  ' + All_Contract_List_Extract.Link__r.Link_id__c;
                    contractExtensionOBJ.Status__c = 'Fill BA Recipient and BA Print';
                    contractExtensionOBJ.Account__c = All_Contract_List_Extract.Accountid;
                    contractExtensionOBJ.Account_Manager__c = All_Contract_List_Extract.Account.Ownerid;
                    contractExtensionOBJ.Link__c = All_Contract_List_Extract.Link__c;
                    contractExtensionOBJ.Existing_Contract_item__c = All_Contract_List_Extract.id;
                    contractExtensionOBJ.Extension_Start_Date__c = extensionStartDate;
                    contractExtensionOBJ.Extension_End_Date__c = extensionEndDate;
                    contractExtensionOBJ.Approved_By_Solution__c = false;

                    if(All_Contract_List_Extract.Link__r.Partner__c == true){
                        contractExtensionOBJ.Link_Partner__c = true;
                    }else{
                        contractExtensionOBJ.Link_Partner__c = false;
                    }

                    //NOVI. 23 agustus 2021 , UPDATE CREATOR BASED ON OWNER ACCOUNT
                    if(All_Contract_List_Extract.Account.Owner.IsActive == True){
                        contractExtensionOBJ.ownerid = All_Contract_List_Extract.Account.Ownerid;
                    }else if(All_Contract_List_Extract.Account.Owner.Manager.IsActive == True){
                        contractExtensionOBJ.ownerid = All_Contract_List_Extract.Account.Owner.ManagerId;
                    }   
                    
                    All_ContractExtension_NEW_List.add(contractExtensionOBJ);

                    All_Contract_List_Extract.status ='Active';
			        All_Contract_List_Extract.extension_created__c = true;
                }
                Database.SaveResult[] insertResults = Database.insert(All_ContractExtension_NEW_List, true);
                update All_Contract_List;

                for (Database.SaveResult insertResults_Extract : insertResults) {
                    if (insertResults_Extract.isSuccess()) {
                        All_ContractExtensionIds.add(insertResults_Extract.getId());
                    }
                    else {          
                        for(Database.Error error : insertResults_Extract.getErrors()) {
                            String err_message = 'Error on Controller_NEW_Contract_Extension.cls - Insert New contractExtensionOBJ ::' + error.getStatusCode() + ': ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields();
                            AppUtils.putError(err_message);
                            System.debug('Error on Controller_NEW_Contract_Extension.cls - Insert New contractExtensionOBJ ::' + error.getStatusCode() + ' : ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields());
                        }
                    }
                }

                if(All_ContractExtensionIds!=null && !All_ContractExtensionIds.isEmpty()){
                    list<Contract_Extension__c> All_ContractExtension_NEW_Insert_List = [SELECT Id, Account__c FROM Contract_Extension__c WHERE Id IN:All_ContractExtensionIds];

                    if(All_ContractExtension_NEW_Insert_List!=null && !All_ContractExtension_NEW_Insert_List.isEmpty()){
                        for(Contract_Extension__c All_ContractExtension_NEW_Insert_List_Extract : All_ContractExtension_NEW_Insert_List){
                            All_accIds.add(All_ContractExtension_NEW_Insert_List_Extract.Account__c);
                        }

                        if(All_accIds!=null && !All_accIds.isEmpty()){
                            Map<Id,Id> getContactBAPrint_Map = new Map<Id,Id>();
                            All_Contact_Information_List = [SELECT ContactId, Contact_Email__c, AccountId, Roles FROM AccountContactRelation WHERE Roles INCLUDES ('PIC BA Recipient','PIC BA Print') AND AccountId IN:All_accIds];

                            if(All_Contact_Information_List!=null && !All_Contact_Information_List.isEmpty()){
                                for(AccountContactRelation All_Contact_Information_List_Extract : All_Contact_Information_List){
                                    if(String.isNotBlank(All_Contact_Information_List_Extract.Contact_Email__c)){
                                        All_accIds_Criteria_Complete.add(All_Contact_Information_List_Extract.AccountId);

                                        if(
                                            All_Contact_Information_List_Extract.Roles.Contains('BA Print') ||
                                            All_Contact_Information_List_Extract.Roles.Contains('PIC BA Recipient')
                                        ){
                                            //system.debug(All_Contact_Information_List_Extract.AccountId);
                                            getContactBAPrint_Map.put(All_Contact_Information_List_Extract.AccountId, All_Contact_Information_List_Extract.ContactId);
                                        }
                                    }
                                }

                                if(All_accIds_Criteria_Complete!=null && !All_accIds_Criteria_Complete.isEmpty()){
                                    All_ContractExtension_Criteria_Complete_List = [SELECT Id, Account__c,Status__c,BA_Print__c FROM Contract_Extension__c WHERE Id IN:All_ContractExtensionIds AND Account__c IN:All_accIds_Criteria_Complete];
                                    //system.debug('All_ContractExtension_Criteria_Complete_List : ' + All_ContractExtension_Criteria_Complete_List.size());

                                    if(All_ContractExtension_Criteria_Complete_List!=null && !All_ContractExtension_Criteria_Complete_List.isEmpty()){
                                        for(Contract_Extension__c All_ContractExtension_Criteria_Complete_List_Extract : All_ContractExtension_Criteria_Complete_List){
                                            if(getContactBAPrint_Map!=null && !getContactBAPrint_Map.isEmpty()){
                                                All_ContractExtension_Criteria_Complete_List_Extract.BA_Print__c = getContactBAPrint_Map.get(All_ContractExtension_Criteria_Complete_List_Extract.Account__c);
                                                //system.debug(All_ContractExtension_Criteria_Complete_List_Extract.Account__c);
                                            }
                                            All_ContractExtension_Criteria_Complete_List_Extract.Status__c = 'Submit';
                                        }
                                        update All_ContractExtension_Criteria_Complete_List;
                                    }

                                    All_ContractExtension_Criteria_NotComplete_List = [SELECT Id, Account__c,Status__c FROM Contract_Extension__c WHERE Id IN:All_ContractExtensionIds AND Account__c NOT IN:All_accIds_Criteria_Complete];
                                    //system.debug('All_ContractExtension_Criteria_NotComplete_List : ' + All_ContractExtension_Criteria_NotComplete_List.size());
                                }
                            }
                        }
                    }
                }
            }
        }catch (Exception e) {
            String err_message = 'Error on Controller_NEW_Contract_Extension.cls - Controller_NEW_Contract_Extension ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }

    }

}