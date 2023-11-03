/**
 * @description       : 
 * @Test Class		  : TEST_Notif_TerminationNonAutoRenewal
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 02-03-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   08-24-2021   Novando Utoyo Agmawan   Initial Version
**/

public class Email_Notif_TerminationNonAutoRenewal {
    public List<Contract_Extension__c> All_contractExtension_List {get; set;}

    public List<Contract_Extension__c> All_contractExtension_1days_List {get; set;}
    public List<Contract_Extension__c> All_contractExtension_14days_List {get; set;}
    public List<Contract_Extension__c> All_contractExtension_30days_List {get; set;}
    public List<Contract_Extension__c> All_contractExtension_60days_List {get; set;}
    public List<Contract_Extension__c> All_contractExtension_90days_List {get; set;}
    public List<Contract_Extension__c> All_contractExtension_SendBACustomer_Button_List {get; set;}

    public List<Messaging.SingleEmailMessage> sendEmailList {get; set;}
    public List<string> List_toAddress_1 {get; set;}
    public List<string> List_toCCAddress_1 {get; set;}
    public List<string> List_toBCCAddress_1 {get; set;}
    public List<string> List_toAddress_1_1 {get; set;}
    public List<string> List_toCCAddress_1_1 {get; set;}
    public List<string> List_toBCCAddress_1_1 {get; set;}
    public List<string> List_toAddress_2 {get; set;}
    public List<string> List_toCCAddress_2 {get; set;}
    public List<string> List_toBCCAddress_2 {get; set;}
    public List<string> List_toAddress_3 {get; set;}
    public List<string> List_toCCAddress_3 {get; set;}
    public List<string> List_toBCCAddress_3 {get; set;}

    public Set<string> Set_toAddress_1 {get; set;}
    public Set<string> Set_toCCAddress_1 {get; set;}
    public Set<string> Set_toBCCAddress_1 {get; set;}
    public Set<string> Set_toAddress_1_1 {get; set;}
    public Set<string> Set_toCCAddress_1_1 {get; set;}
    public Set<string> Set_toBCCAddress_1_1 {get; set;}
    public Set<string> Set_toAddress_2 {get; set;}
    public Set<string> Set_toCCAddress_2 {get; set;}
    public Set<string> Set_toBCCAddress_2 {get; set;}
    public Set<string> Set_toAddress_3 {get; set;}
    public Set<string> Set_toCCAddress_3 {get; set;}
    public Set<string> Set_toBCCAddress_3 {get; set;}

    public Map<String, string> toAddress_EmailTerminationNonAutoRenewal_Setting_Map{ get; set;}
    public Map<String, string> toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map{ get; set;}
    public Map<String, string> toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map{ get; set;}

    public List<string>  Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_List  {get; set;}
    public List<string>  Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List {get; set;}
    public List<string>  Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List {get; set;}
    public Set<string>  Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET  {get; set;}
    public Set<string>  Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET {get; set;}
    public Set<string>  Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET {get; set;}

    public List<string>  Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List  {get; set;}
    public List<string>  Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List {get; set;}
    public List<string>  Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List {get; set;}
    public Set<string>  Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET  {get; set;}
    public Set<string>  Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET {get; set;}
    public Set<string>  Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET {get; set;}

    public List<string>  Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List  {get; set;}
    public List<string>  Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List {get; set;}
    public List<string>  Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List {get; set;}
    public Set<string>  Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET  {get; set;}
    public Set<string>  Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET {get; set;}
    public Set<string>  Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET {get; set;}


    public Map<Id,string> All_Contact_PICBARecipient {get; set;}
    public Map<Id,string> All_Email_Head_Sales {get; set;}
    public Map<Id, string> Name_User_HeadSales{ get; set;}
    public Map<Id,string> All_Email_GH_Sales {get; set;}
    public Map<Id, string> Name_User_GHSales{ get; set;}

    Set<Id> contractExtension_List_AccountId {get; set;}
    Set<Id> contractExtension_List_Email_Head_Sales {get; set;}
    Set<Id> contractExtension_List_Email_GH_Sales  {get; set;}

    public EmailTemplate emailTemplate{ get; set;}

    public Email_Notif_TerminationNonAutoRenewal(List<Contract_Extension__c> FetchAll_contractExtension_List, Boolean dynamicEmail){
        DateTime start_time = datetime.now();
        All_contractExtension_List = FetchAll_contractExtension_List;

        sendEmailList = new List<Messaging.SingleEmailMessage>();

        All_contractExtension_1days_List = new List<Contract_Extension__c>();
        All_contractExtension_14days_List = new List<Contract_Extension__c>();
        All_contractExtension_30days_List = new List<Contract_Extension__c>();
        All_contractExtension_60days_List = new List<Contract_Extension__c>();
        All_contractExtension_90days_List = new List<Contract_Extension__c>();
        All_contractExtension_SendBACustomer_Button_List = new List<Contract_Extension__c>();

        emailTemplate = [Select id, htmlValue, subject from EmailTemplate where DeveloperName = 'Email_NOTIF1_TENAR_ForH1_EXTERNAL'];

        system.debug('Email_Notif_TerminationNonAutoRenewal emailTemplate : ' + FetchAll_ContractExtension_List);

        try {
            if(All_contractExtension_List!=null && !All_contractExtension_List.isEmpty()){
                getEmailTerminationNonAutoRenewal_Setting();

                for(Contract_Extension__c All_contractExtension_List_Extract : All_contractExtension_List){
                    //system.debug('All_contractExtension_List_Extract : '+ All_contractExtension_List_Extract.Name);

                    if(dynamicEmail == false){
                        if(
                            All_contractExtension_List_Extract.Status__c == 'Waiting for BA' ||
                            All_contractExtension_List_Extract.Status__c == 'Fill BA Recipient and BA Print' ||
                            All_contractExtension_List_Extract.Status__c == 'Waiting Solution Approval'
                        ){
                            if(All_contractExtension_List_Extract.Existing_Contract_item__r.End_Date__c == system.today().adddays(14)){
                                All_contractExtension_14days_List.add(All_contractExtension_List_Extract);
                            }
                            else if(All_contractExtension_List_Extract.Existing_Contract_item__r.End_Date__c == system.today().adddays(30)){
                                All_contractExtension_30days_List.add(All_contractExtension_List_Extract);
                            }
                            else if(All_contractExtension_List_Extract.Existing_Contract_item__r.End_Date__c == system.today().adddays(60)){
                                All_contractExtension_60days_List.add(All_contractExtension_List_Extract);
                            }
                            else if(All_contractExtension_List_Extract.Existing_Contract_item__r.End_Date__c == system.today().adddays(90)){
                                All_contractExtension_90days_List.add(All_contractExtension_List_Extract);
                            }
                        }

                        if(
                            All_contractExtension_List_Extract.Status__c == 'Waiting for BA' ||
                            All_contractExtension_List_Extract.Status__c == 'Completed'  ||
                            All_contractExtension_List_Extract.Status__c == 'Fill BA Recipient and BA Print' ||
                            All_contractExtension_List_Extract.Status__c == 'Waiting Solution Approval'
                        ){
                            if(All_contractExtension_List_Extract.Existing_Contract_item__r.End_Date__c == system.today().adddays(1)){
                                All_contractExtension_1days_List.add(All_contractExtension_List_Extract);
                            }
                        }
                    }
                    else{
                        All_contractExtension_SendBACustomer_Button_List.add(All_contractExtension_List_Extract);
                    }
                }
            }

            if(All_contractExtension_1days_List!=null && !All_contractExtension_1days_List.isEmpty()){
                system.debug('All_contractExtension_1days_List_SIZE : '+ All_contractExtension_1days_List.size());

                contractExtension_List_AccountId = new Set<Id>();
                contractExtension_List_Email_Head_Sales = new Set<Id>();
                contractExtension_List_Email_GH_Sales = new Set<Id>();

                for(Contract_Extension__c All_contractExtension_1days_List_Extract : All_contractExtension_1days_List){
                    contractExtension_List_AccountId.add(All_contractExtension_1days_List_Extract.Account__c);
                    contractExtension_List_Email_Head_Sales.add(All_contractExtension_1days_List_Extract.Account_Manager__r.ManagerId);
                    contractExtension_List_Email_GH_Sales.add(All_contractExtension_1days_List_Extract.Account_Manager__r.ManagerId);
                }

                //system.debug('contractExtension_List_AccountId 14 : ' + contractExtension_List_AccountId);

                All_Contact_PICBARecipient = getContact_PICBARecipient(contractExtension_List_AccountId);
                All_Email_Head_Sales = getHead_Sales(contractExtension_List_Email_Head_Sales);
                All_Email_GH_Sales = getGH_Sales(contractExtension_List_Email_GH_Sales);

                /*system.debug('SIZE All_Contact_PICBARecipient :'+ All_Contact_PICBARecipient.size());
                system.debug('All_Contact_PICBARecipient :'+ All_Contact_PICBARecipient.size());*/

                Extract_Email_1_TerminationNonAutoRenewal_Setting('Email_1_1Hari_Setting');
                Extract_Email_2_TerminationNonAutoRenewal_Setting('Email_2_1Hari_Setting');
                Extract_Email_3_TerminationNonAutoRenewal_Setting('Email_3_NoticeAdmin_Setting');

                Boolean dataLengkap = true;

                for(Contract_Extension__c All_contractExtension_1days_List_Extract : All_contractExtension_1days_List){
                    List_toAddress_1 = new List<string>();
                    List_toCCAddress_1 = new List<string>();
                    List_toBCCAddress_1 = new List<string>();
                    List_toAddress_2 = new List<string>();
                    List_toCCAddress_2 = new List<string>();
                    List_toBCCAddress_2 = new List<string>();
                    List_toAddress_3 = new List<string>();
                    List_toCCAddress_3 = new List<string>();
                    List_toBCCAddress_3 = new List<string>();

                    Set_toAddress_1 = new Set<string>();
                    Set_toCCAddress_1 = new Set<string>();
                    Set_toBCCAddress_1 = new Set<string>();
                    Set_toAddress_2 = new Set<string>();
                    Set_toCCAddress_2 = new Set<string>();
                    Set_toBCCAddress_2 = new Set<string>();
                    Set_toAddress_3 = new Set<string>();
                    Set_toCCAddress_3 = new Set<string>();
                    Set_toBCCAddress_3 = new Set<string>();

                    //system.debug('AccountId 1 hari : ' + All_contractExtension_1days_List_Extract.Account__c);

                    //------------- START SET EMAIL ADDRESS 2 -----------------------
                    if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET.isEmpty()) {
                        Set_toAddress_2.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET);
                    }

                    if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET.isEmpty()) {
                        Set_toCCAddress_2.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET);
                    }

                    if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET.isEmpty()) {
                        Set_toBCCAddress_2.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET);
                    }

                    if(All_contractExtension_1days_List_Extract.Account_Manager__r.Email != null){
                        Set_toAddress_2.add(All_contractExtension_1days_List_Extract.Account_Manager__r.Email);
                    }

                    if(All_Email_Head_Sales.get(All_contractExtension_1days_List_Extract.Account_Manager__r.ManagerId) != null){
                        Set_toAddress_2.add(All_Email_Head_Sales.get(All_contractExtension_1days_List_Extract.Account_Manager__r.ManagerId));
                    }

                    if(All_Email_GH_Sales.get(All_contractExtension_1days_List_Extract.Account_Manager__r.Manager_of_Manager__c) != null){
                        Set_toAddress_2.add(All_Email_GH_Sales.get(All_contractExtension_1days_List_Extract.Account_Manager__r.Manager_of_Manager__c));
                    }

                    Set_toAddress_2.remove('');
                    Set_toAddress_2.remove(null);
                    List_toAddress_2.addAll(Set_toAddress_2);

                    Set_toCCAddress_2.remove('');
                    Set_toCCAddress_2.remove(null);
                    List_toCCAddress_2.addAll(Set_toCCAddress_2);

                    Set_toBCCAddress_2.remove('');
                    Set_toBCCAddress_2.remove(null);
                    List_toBCCAddress_2.addAll(Set_toBCCAddress_2);
                    //------------- END SET EMAIL ADDRESS 2 -----------------------

                    String contract_name = All_contractExtension_1days_List_Extract.name;
                    String customer_name = All_contractExtension_1days_List_Extract.Account__r.Name;
                    //String dateValue = '1';
                    Integer dateValueINT = Integer.valueOf(All_contractExtension_1days_List_Extract.Going_To_Days__c);
                    String dateValue = String.valueOf(dateValueINT);
                    
                    String dateValueIND = 'satu';
                    String dateValueEN = 'one';
                    String product_name = All_contractExtension_1days_List_Extract.Existing_Contract_item__r.Product__r.Name;
                    String LID = All_contractExtension_1days_List_Extract.Link__r.Link_ID__c;
                    String site_name = '';
                    if(String.isNotBlank(All_contractExtension_1days_List_Extract.Link__r.Site_A_Name__r.Name) && String.isNotBlank(All_contractExtension_1days_List_Extract.Link__r.Site_A_Name__r.Unique_Name__c)){
                        site_name = All_contractExtension_1days_List_Extract.Link__r.Site_A_Name__r.Name + ' ' + All_contractExtension_1days_List_Extract.Link__r.Site_A_Name__r.Unique_Name__c;
                    }else{
                        site_name = All_contractExtension_1days_List_Extract.Link__r.Site_A_Name__r.Name;
                    }

                    String site_name2 = '';
                    if(String.isNotBlank(All_contractExtension_1days_List_Extract.Link__r.Site_A_Name__r.Unique_Name__c)){
                        site_name2 = All_contractExtension_1days_List_Extract.Link__r.Site_A_Name__r.Unique_Name__c;
                    }

                    Date contract_end_date_value = All_contractExtension_1days_List_Extract.Existing_Contract_item__r.End_Date__c;
                    String contract_end_date_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_value);
                    String contract_end_date = contract_end_date_value.day() + ' ' + contract_end_date_month + ' ' + contract_end_date_value.year();
                    String contract_end_date_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_value);
                    String contract_end_date_EN = contract_end_date_value.day() + ' ' + contract_end_date_month_EN + ' ' + contract_end_date_value.year();

                    Date contract_end_date_plus_1_hari_value = All_contractExtension_1days_List_Extract.Existing_Contract_item__r.End_Date__c.addDays(1);
                    String contract_end_date_plus_1_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_plus_1_hari_value);
                    String contract_end_date_plus_1_hari = contract_end_date_plus_1_hari_value.day() + ' ' + contract_end_date_plus_1_hari_month + ' ' + contract_end_date_plus_1_hari_value.year();
                    String contract_end_date_plus_1_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_plus_1_hari_value);
                    String contract_end_date_plus_1_hari_EN = contract_end_date_plus_1_hari_value.day() + ' ' + contract_end_date_plus_1_hari_month_EN + ' ' + contract_end_date_plus_1_hari_value.year();

                    Date contract_end_date_minus_14_hari_value = All_contractExtension_1days_List_Extract.Existing_Contract_item__r.End_Date__c.addDays(-14);
                    String contract_end_date_minus_14_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_minus_14_hari_value);
                    String contract_end_date_minus_14_hari  = contract_end_date_minus_14_hari_value.day() + ' ' + contract_end_date_minus_14_hari_month + ' ' + contract_end_date_minus_14_hari_value.year();
                    String contract_end_date_minus_14_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_minus_14_hari_value);
                    String contract_end_date_minus_14_hari_EN  = contract_end_date_minus_14_hari_value.day() + ' ' + contract_end_date_minus_14_hari_month_EN + ' ' + contract_end_date_minus_14_hari_value.year();

                    Date contract_end_date_minus_30_hari_value = All_contractExtension_1days_List_Extract.Existing_Contract_item__r.End_Date__c.addDays(30);
                    String contract_end_date_minus_30_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_minus_30_hari_value);
                    String contract_end_date_minus_30_hari  = contract_end_date_minus_30_hari_value.day() + ' ' + contract_end_date_minus_30_hari_month + ' ' + contract_end_date_minus_30_hari_value.year();
                    String contract_end_date_minus_30_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_minus_30_hari_value);
                    String contract_end_date_minus_30_hari_EN  = contract_end_date_minus_30_hari_value.day() + ' ' + contract_end_date_minus_30_hari_month_EN + ' ' + contract_end_date_minus_30_hari_value.year();

                    String AM_name = All_contractExtension_1days_List_Extract.Account_Manager__r.Name;
                    String Head_name = Name_User_HeadSales.get(All_contractExtension_1days_List_Extract.Account_Manager__r.ManagerId);
                    String GH_name = Name_User_GHSales.get(All_contractExtension_1days_List_Extract.Account_Manager__r.Manager_of_Manager__c);

                    String Recordlink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+All_contractExtension_1days_List_Extract.BAP__c;
                    String BAP_no = All_contractExtension_1days_List_Extract.BAP__r.Name;

                    String no_surat = 'Final';
                    String no_surat_suffix = ' reminder for ';

                    String ContractExtensionid = All_contractExtension_1days_List_Extract.Id;

                    if(
                        (
                            All_contractExtension_1days_List_Extract.BA_Print__r.Email != null || All_contractExtension_1days_List_Extract.BA_Print__c != null
                        ) &&
                        (
                            All_contractExtension_1days_List_Extract.Status__c == 'Waiting for BA' ||
                            All_contractExtension_1days_List_Extract.Status__c == 'Completed' ||
                            Test.isRunningTest()
                        )
                    ){
                        //------------- START SET EMAIL ADDRESS 1 -----------------------
                        if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toAddress_1.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toCCAddress_1.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toBCCAddress_1.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        Set_toAddress_1.add(All_contractExtension_1days_List_Extract.BA_Print__r.Email);

                        if(All_Contact_PICBARecipient.get(All_contractExtension_1days_List_Extract.Account__c) != null){
                            Set_toAddress_1.add(All_Contact_PICBARecipient.get(All_contractExtension_1days_List_Extract.Account__c));
                        }
                        
                        if(All_contractExtension_1days_List_Extract.Account_Manager__r.Email != null){
                            Set_toCCAddress_1.add(All_contractExtension_1days_List_Extract.Account_Manager__r.Email);
                        }

                        if(All_Email_Head_Sales.get(All_contractExtension_1days_List_Extract.Account_Manager__r.ManagerId) != null){
                            Set_toCCAddress_1.add(All_Email_Head_Sales.get(All_contractExtension_1days_List_Extract.Account_Manager__r.ManagerId));
                        }

                        if(All_Email_GH_Sales.get(All_contractExtension_1days_List_Extract.Account_Manager__r.Manager_of_Manager__c) != null){
                            Set_toCCAddress_1.add(All_Email_GH_Sales.get(All_contractExtension_1days_List_Extract.Account_Manager__r.Manager_of_Manager__c));
                        }

                        Set_toAddress_1.remove('');
                        Set_toAddress_1.remove(null);
                        List_toAddress_1.addAll(Set_toAddress_1);

                        Set_toCCAddress_1.remove('');
                        Set_toCCAddress_1.remove(null);
                        List_toCCAddress_1.addAll(Set_toCCAddress_1);

                        Set_toBCCAddress_1.remove('');
                        Set_toBCCAddress_1.remove(null);
                        List_toBCCAddress_1.addAll(Set_toBCCAddress_1);
                        //------------- END SET EMAIL ADDRESS 1 -----------------------

                        if(
                            All_contractExtension_1days_List_Extract.Status__c == 'Completed' &&
                            All_contractExtension_1days_List_Extract.Complete_Status__c == 'Canceled'
                        ){
                            sendEmailList.add(
                                sendEmail_1_ForH1(
                                    ContractExtensionid,
                                    List_toAddress_1,
                                    List_toCCAddress_1,
                                    List_toBCCAddress_1,
                                    no_surat,
                                    no_surat_suffix,
                                    contract_name,
                                    customer_name,
                                    dateValue,
                                    dateValueIND,
                                    dateValueEN,
                                    product_name,
                                    LID,
                                    site_name,
                                    site_name2,
                                    contract_end_date,
                                    contract_end_date_plus_1_hari,
                                    contract_end_date_minus_14_hari,
                                    contract_end_date_EN,
                                    contract_end_date_plus_1_hari_EN,
                                    contract_end_date_minus_14_hari_EN,
                                    dataLengkap
                                )
                            );
                        }

                        sendEmailList.add(
                            sendEmail_2(
                                List_toAddress_2, 
                                List_toCCAddress_2,
                                List_toBCCAddress_2,
                                no_surat,
                                no_surat_suffix,
                                contract_name,
                                AM_name,
                                Head_name,
                                GH_name,
                                dateValue,
                                dateValueIND,
                                product_name,
                                LID,
                                customer_name,
                                site_name,
                                site_name2,
                                contract_end_date,
                                contract_end_date_minus_14_hari,
                                contract_end_date_plus_1_hari,
                                contract_end_date_minus_30_hari,
                                Recordlink,
                                BAP_no
                            )
                        );
                    }else{
                        Set_toAddress_3.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);
                        Set_toCCAddress_3.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);
                        Set_toBCCAddress_3.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);

                        List_toAddress_3.addAll(Set_toAddress_3);
                        List_toCCAddress_3.addAll(Set_toCCAddress_3);
                        List_toBCCAddress_3.addAll(Set_toBCCAddress_3);

                        String contractId = All_contractExtension_1days_List_Extract.id;
                        String PIC_BA_Print = All_contractExtension_1days_List_Extract.BA_Print__r.Name;
                        String Email = All_contractExtension_1days_List_Extract.BA_Print__r.email;

                        sendEmailList.add(
                            sendEmail_3(
                                List_toAddress_3, 
                                List_toCCAddress_3,
                                List_toBCCAddress_3,
                                contract_name,
                                contractId,
                                PIC_BA_Print,
                                Email
                            )
                        );

                        dataLengkap = false;

                        no_surat = '';
                        no_surat_suffix = '';

                        //------------- START SET EMAIL ADDRESS 1 -----------------------
                        Extract_Email_1_TerminationNonAutoRenewal_Setting('Email_1_1Hari_Setting');

                        if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toAddress_1.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toCCAddress_1.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toBCCAddress_1.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(All_contractExtension_1days_List_Extract.Account_Manager__r.Email != null){
                            Set_toAddress_1.add(All_contractExtension_1days_List_Extract.Account_Manager__r.Email);
                        }

                        if(All_Email_Head_Sales.get(All_contractExtension_1days_List_Extract.Account_Manager__r.ManagerId) != null){
                            Set_toAddress_1.add(All_Email_Head_Sales.get(All_contractExtension_1days_List_Extract.Account_Manager__r.ManagerId));
                        }

                        if(All_Email_GH_Sales.get(All_contractExtension_1days_List_Extract.Account_Manager__r.Manager_of_Manager__c) != null){
                            Set_toAddress_1.add(All_Email_GH_Sales.get(All_contractExtension_1days_List_Extract.Account_Manager__r.Manager_of_Manager__c));
                        }

                        Set_toAddress_1.remove('');
                        Set_toAddress_1.remove(null);
                        List_toAddress_1.addAll(Set_toAddress_1);

                        Set_toCCAddress_1.remove('');
                        Set_toCCAddress_1.remove(null);
                        List_toCCAddress_1.addAll(Set_toCCAddress_1);

                        Set_toBCCAddress_1.remove('');
                        Set_toBCCAddress_1.remove(null);
                        List_toBCCAddress_1.addAll(Set_toBCCAddress_1);
                        //------------- END SET EMAIL ADDRESS 1 -----------------------

                        sendEmailList.add(
                            sendEmail_1_ForH1(
                                ContractExtensionid,
                                List_toAddress_1,
                                List_toCCAddress_1,
                                List_toBCCAddress_1,
                                no_surat,
                                no_surat_suffix,
                                contract_name,
                                customer_name,
                                dateValue,
                                dateValueIND,
                                dateValueEN,
                                product_name,
                                LID,
                                site_name,
                                site_name2,
                                contract_end_date,
                                contract_end_date_plus_1_hari,
                                contract_end_date_minus_14_hari,
                                contract_end_date_EN,
                                contract_end_date_plus_1_hari_EN,
                                contract_end_date_minus_14_hari_EN,
                                dataLengkap
                            )
                        );

                        sendEmailList.add(
                            sendEmail_2(
                                List_toAddress_2, 
                                List_toCCAddress_2,
                                List_toBCCAddress_2,
                                no_surat,
                                no_surat_suffix,
                                contract_name,
                                AM_name,
                                Head_name,
                                GH_name,
                                dateValue,
                                dateValueIND,
                                product_name,
                                LID,
                                customer_name,
                                site_name,
                                site_name2,
                                contract_end_date,
                                contract_end_date_minus_14_hari,
                                contract_end_date_plus_1_hari,
                                contract_end_date_minus_30_hari,
                                Recordlink,
                                BAP_no
                            )
                        );
                    }
                }

                /*system.debug('Set_toAddress_1 :'+ Set_toAddress_1);
                system.debug('Set_toCCAddress_1 :'+ Set_toCCAddress_1);
                system.debug('Set_toAddress_2 :'+ Set_toAddress_2);
                system.debug('Set_toCCAddress_2 :'+ Set_toCCAddress_2);*/

                system.debug('List_toAddress_1 All_contractExtension_1days_List_List :'+ List_toAddress_1);
                system.debug('List_toCCAddress_1 All_contractExtension_1days_List_List :'+ List_toCCAddress_1);
                system.debug('List_toBCCAddress_1 All_contractExtension_1days_List_List :'+ List_toBCCAddress_1);
                system.debug('List_toAddress_2 All_contractExtension_1days_List_List :'+ List_toAddress_2);
                system.debug('List_toCCAddress_2 All_contractExtension_1days_List_List :'+ List_toCCAddress_2);
                system.debug('List_toBCCAddress_2 All_contractExtension_1days_List_List :'+ List_toBCCAddress_2);
            }

            if(All_contractExtension_14days_List!=null && !All_contractExtension_14days_List.isEmpty()){
                system.debug('All_contractExtension_14days_List_SIZE : '+ All_contractExtension_14days_List.size());

                contractExtension_List_AccountId = new Set<Id>();
                contractExtension_List_Email_Head_Sales = new Set<Id>();
                contractExtension_List_Email_GH_Sales = new Set<Id>();

                List<Contract_Extension__c> List_ContractExtension_UPD = new List<Contract_Extension__c> ();

                for(Contract_Extension__c All_contractExtension_14days_List_Extract : All_contractExtension_14days_List){
                    contractExtension_List_AccountId.add(All_contractExtension_14days_List_Extract.Account__c);
                    contractExtension_List_Email_Head_Sales.add(All_contractExtension_14days_List_Extract.Account_Manager__r.ManagerId);
                    contractExtension_List_Email_GH_Sales.add(All_contractExtension_14days_List_Extract.Account_Manager__r.ManagerId);
                }

                //system.debug('contractExtension_List_AccountId 14 : ' + contractExtension_List_AccountId);

                All_Contact_PICBARecipient = getContact_PICBARecipient(contractExtension_List_AccountId);
                All_Email_Head_Sales = getHead_Sales(contractExtension_List_Email_Head_Sales);
                All_Email_GH_Sales = getGH_Sales(contractExtension_List_Email_GH_Sales);

                /*system.debug('SIZE All_Contact_PICBARecipient :'+ All_Contact_PICBARecipient.size());
                system.debug('All_Contact_PICBARecipient :'+ All_Contact_PICBARecipient.size());*/

                Extract_Email_1_TerminationNonAutoRenewal_Setting('Email_1_14Hari_Setting');
                Extract_Email_2_TerminationNonAutoRenewal_Setting('Email_2_14Hari_Setting');
                Extract_Email_3_TerminationNonAutoRenewal_Setting('Email_3_NoticeAdmin_Setting');

                Boolean dataLengkap = true;

                for(Contract_Extension__c All_contractExtension_14days_List_Extract : All_contractExtension_14days_List){
                    List_toAddress_1 = new List<string>();
                    List_toCCAddress_1 = new List<string>();
                    List_toBCCAddress_1 = new List<string>();
                    List_toAddress_2 = new List<string>();
                    List_toCCAddress_2 = new List<string>();
                    List_toBCCAddress_2 = new List<string>();
                    List_toAddress_3 = new List<string>();
                    List_toCCAddress_3 = new List<string>();
                    List_toBCCAddress_3 = new List<string>();

                    Set_toAddress_1 = new Set<string>();
                    Set_toCCAddress_1 = new Set<string>();
                    Set_toBCCAddress_1 = new Set<string>();
                    Set_toAddress_2 = new Set<string>();
                    Set_toCCAddress_2 = new Set<string>();
                    Set_toBCCAddress_2 = new Set<string>();
                    Set_toAddress_3 = new Set<string>();
                    Set_toCCAddress_3 = new Set<string>();
                    Set_toBCCAddress_3 = new Set<string>();

                    //system.debug('AccountId 14 : ' + All_contractExtension_14days_List_Extract.Account__c);

                    //------------- START SET EMAIL ADDRESS 2 -----------------------
                    if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET.isEmpty()) {
                        Set_toAddress_2.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET);
                    }

                    if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET.isEmpty()) {
                        Set_toCCAddress_2.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET);
                    }

                    if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET.isEmpty()) {
                        Set_toBCCAddress_2.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET);
                    }

                    if(All_contractExtension_14days_List_Extract.Account_Manager__r.Email != null){
                        Set_toAddress_2.add(All_contractExtension_14days_List_Extract.Account_Manager__r.Email);
                    }

                    if(All_Email_Head_Sales.get(All_contractExtension_14days_List_Extract.Account_Manager__r.ManagerId) != null){
                        Set_toAddress_2.add(All_Email_Head_Sales.get(All_contractExtension_14days_List_Extract.Account_Manager__r.ManagerId));
                    }

                    if(All_Email_GH_Sales.get(All_contractExtension_14days_List_Extract.Account_Manager__r.Manager_of_Manager__c) != null){
                        Set_toAddress_2.add(All_Email_GH_Sales.get(All_contractExtension_14days_List_Extract.Account_Manager__r.Manager_of_Manager__c));
                    }

                    Set_toAddress_2.remove('');
                    Set_toAddress_2.remove(null);
                    List_toAddress_2.addAll(Set_toAddress_2);

                    Set_toCCAddress_2.remove('');
                    Set_toCCAddress_2.remove(null);
                    List_toCCAddress_2.addAll(Set_toCCAddress_2);

                    Set_toBCCAddress_2.remove('');
                    Set_toBCCAddress_2.remove(null);
                    List_toBCCAddress_2.addAll(Set_toBCCAddress_2);
                    //------------- END SET EMAIL ADDRESS 2 -----------------------

                    String contract_name = All_contractExtension_14days_List_Extract.name;
                    String customer_name = All_contractExtension_14days_List_Extract.Account__r.Name;
                    //String dateValue = '14';
                    Integer dateValueINT = Integer.valueOf(All_contractExtension_14days_List_Extract.Going_To_Days__c);
                    String dateValue = String.valueOf(dateValueINT);
                    
                    String dateValueIND = 'empat belas';
                    String dateValueEN = 'fourteen';
                    String product_name = All_contractExtension_14days_List_Extract.Existing_Contract_item__r.Product__r.Name;
                    String LID = All_contractExtension_14days_List_Extract.Link__r.Link_ID__c;
                    String site_name = '';
                    if(String.isNotBlank(All_contractExtension_14days_List_Extract.Link__r.Site_A_Name__r.Name) && String.isNotBlank(All_contractExtension_14days_List_Extract.Link__r.Site_A_Name__r.Unique_Name__c)){
                        site_name = All_contractExtension_14days_List_Extract.Link__r.Site_A_Name__r.Name + ' ' + All_contractExtension_14days_List_Extract.Link__r.Site_A_Name__r.Unique_Name__c;
                    }else{
                        site_name = All_contractExtension_14days_List_Extract.Link__r.Site_A_Name__r.Name;
                    }

                    String site_name2 = '';
                    if(String.isNotBlank(All_contractExtension_14days_List_Extract.Link__r.Site_A_Name__r.Unique_Name__c)){
                        site_name2 = All_contractExtension_14days_List_Extract.Link__r.Site_A_Name__r.Unique_Name__c;
                    }

                    Date contract_end_date_value = All_contractExtension_14days_List_Extract.Existing_Contract_item__r.End_Date__c;
                    String contract_end_date_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_value);
                    String contract_end_date = contract_end_date_value.day() + ' ' + contract_end_date_month + ' ' + contract_end_date_value.year();
                    String contract_end_date_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_value);
                    String contract_end_date_EN = contract_end_date_value.day() + ' ' + contract_end_date_month_EN + ' ' + contract_end_date_value.year();

                    Date contract_end_date_plus_1_hari_value = All_contractExtension_14days_List_Extract.Existing_Contract_item__r.End_Date__c.addDays(1);
                    String contract_end_date_plus_1_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_plus_1_hari_value);
                    String contract_end_date_plus_1_hari = contract_end_date_plus_1_hari_value.day() + ' ' + contract_end_date_plus_1_hari_month + ' ' + contract_end_date_plus_1_hari_value.year();
                    String contract_end_date_plus_1_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_plus_1_hari_value);
                    String contract_end_date_plus_1_hari_EN = contract_end_date_plus_1_hari_value.day() + ' ' + contract_end_date_plus_1_hari_month_EN + ' ' + contract_end_date_plus_1_hari_value.year();

                    Date contract_end_date_minus_14_hari_value = All_contractExtension_14days_List_Extract.Existing_Contract_item__r.End_Date__c.addDays(-14);
                    String contract_end_date_minus_14_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_minus_14_hari_value);
                    String contract_end_date_minus_14_hari  = contract_end_date_minus_14_hari_value.day() + ' ' + contract_end_date_minus_14_hari_month + ' ' + contract_end_date_minus_14_hari_value.year();
                    String contract_end_date_minus_14_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_minus_14_hari_value);
                    String contract_end_date_minus_14_hari_EN  = contract_end_date_minus_14_hari_value.day() + ' ' + contract_end_date_minus_14_hari_month_EN + ' ' + contract_end_date_minus_14_hari_value.year();

                    Date contract_end_date_minus_30_hari_value = All_contractExtension_14days_List_Extract.Existing_Contract_item__r.End_Date__c.addDays(30);
                    String contract_end_date_minus_30_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_minus_30_hari_value);
                    String contract_end_date_minus_30_hari  = contract_end_date_minus_30_hari_value.day() + ' ' + contract_end_date_minus_30_hari_month + ' ' + contract_end_date_minus_30_hari_value.year();
                    String contract_end_date_minus_30_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_minus_30_hari_value);
                    String contract_end_date_minus_30_hari_EN  = contract_end_date_minus_30_hari_value.day() + ' ' + contract_end_date_minus_30_hari_month_EN + ' ' + contract_end_date_minus_30_hari_value.year();

                    String AM_name = All_contractExtension_14days_List_Extract.Account_Manager__r.Name;
                    String Head_name = Name_User_HeadSales.get(All_contractExtension_14days_List_Extract.Account_Manager__r.ManagerId);
                    String GH_name = Name_User_GHSales.get(All_contractExtension_14days_List_Extract.Account_Manager__r.Manager_of_Manager__c);

                    String Recordlink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+All_contractExtension_14days_List_Extract.BAP__c;
                    String BAP_no = All_contractExtension_14days_List_Extract.BAP__r.Name;

                    String ContractExtensionid = All_contractExtension_14days_List_Extract.Id;

                    if(
                        (
                            All_contractExtension_14days_List_Extract.BA_Print__r.Email != null || All_contractExtension_14days_List_Extract.BA_Print__c != null 
                        ) &&
                        (
                            All_contractExtension_14days_List_Extract.Status__c == 'Waiting for BA' ||
                            Test.isRunningTest()
                        )
                    ){
                        //------------- START SET EMAIL ADDRESS 1 -----------------------
                        if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toAddress_1.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toCCAddress_1.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toBCCAddress_1.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }
                        
                        Set_toAddress_1.add(All_contractExtension_14days_List_Extract.BA_Print__r.Email);
                        

                        if(All_Contact_PICBARecipient.get(All_contractExtension_14days_List_Extract.Account__c) != null){
                            Set_toAddress_1.add(All_Contact_PICBARecipient.get(All_contractExtension_14days_List_Extract.Account__c));
                        }
                        
                        if(All_contractExtension_14days_List_Extract.Account_Manager__r.Email != null){
                            Set_toCCAddress_1.add(All_contractExtension_14days_List_Extract.Account_Manager__r.Email);
                        }

                        if(All_Email_Head_Sales.get(All_contractExtension_14days_List_Extract.Account_Manager__r.ManagerId) != null){
                            Set_toCCAddress_1.add(All_Email_Head_Sales.get(All_contractExtension_14days_List_Extract.Account_Manager__r.ManagerId));
                        }

                        if(All_Email_GH_Sales.get(All_contractExtension_14days_List_Extract.Account_Manager__r.Manager_of_Manager__c) != null){
                            Set_toCCAddress_1.add(All_Email_GH_Sales.get(All_contractExtension_14days_List_Extract.Account_Manager__r.Manager_of_Manager__c));
                        }

                        Set_toAddress_1.remove('');
                        Set_toAddress_1.remove(null);
                        List_toAddress_1.addAll(Set_toAddress_1);

                        Set_toCCAddress_1.remove('');
                        Set_toCCAddress_1.remove(null);
                        List_toCCAddress_1.addAll(Set_toCCAddress_1);

                        Set_toBCCAddress_1.remove('');
                        Set_toBCCAddress_1.remove(null);
                        List_toBCCAddress_1.addAll(Set_toBCCAddress_1);
                        //------------- END SET EMAIL ADDRESS 1 -----------------------

                        Integer no_suratCount = 0 + 1;

                        If(All_contractExtension_14days_List_Extract.Email_Tenar_Count__c != null){
                            no_suratCount = Integer.ValueOf(All_contractExtension_14days_List_Extract.Email_Tenar_Count__c) + 1;
                        }
    
                        All_contractExtension_14days_List_Extract.Email_Tenar_Count__c = no_suratCount;
                        List_ContractExtension_UPD.add(All_contractExtension_14days_List_Extract);
                        
                        String no_surat = String.ValueOf(no_suratCount);
                        String no_surat_suffix = appUtils.getNumberSuffix(Integer.ValueOf(no_surat));
    
                        String no_surat2 = '';
                        String no_surat_suffix2 = '';

                        sendEmailList.add(
                            sendEmail_1(
                                ContractExtensionid,
                                List_toAddress_1,
                                List_toCCAddress_1,
                                List_toBCCAddress_1,
                                no_surat,
                                no_surat_suffix,
                                contract_name,
                                customer_name,
                                dateValue,
                                dateValueIND,
                                dateValueEN,
                                product_name,
                                LID,
                                site_name,
                                site_name2,
                                contract_end_date,
                                contract_end_date_plus_1_hari,
                                contract_end_date_minus_14_hari,
                                contract_end_date_EN,
                                contract_end_date_plus_1_hari_EN,
                                contract_end_date_minus_14_hari_EN,
                                dataLengkap
                            )
                        );

                        sendEmailList.add(
                            sendEmail_2(
                                List_toAddress_2, 
                                List_toCCAddress_2,
                                List_toBCCAddress_2,
                                no_surat2,
                                no_surat_suffix2,
                                contract_name,
                                AM_name,
                                Head_name,
                                GH_name,
                                dateValue,
                                dateValueIND,
                                product_name,
                                LID,
                                customer_name,
                                site_name,
                                site_name2,
                                contract_end_date,
                                contract_end_date_minus_14_hari,
                                contract_end_date_plus_1_hari,
                                contract_end_date_minus_30_hari,
                                Recordlink,
                                BAP_no
                            )
                        );
                    }else{
                        Set_toAddress_3.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);
                        Set_toCCAddress_3.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);
                        Set_toBCCAddress_3.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);

                        List_toAddress_3.addAll(Set_toAddress_3);
                        List_toCCAddress_3.addAll(Set_toCCAddress_3);
                        List_toBCCAddress_3.addAll(Set_toBCCAddress_3);

                        String contractId = All_contractExtension_14days_List_Extract.id;
                        String PIC_BA_Print = All_contractExtension_14days_List_Extract.BA_Print__r.Name;
                        String Email = All_contractExtension_14days_List_Extract.BA_Print__r.email;

                        sendEmailList.add(
                            sendEmail_3(
                                List_toAddress_3, 
                                List_toCCAddress_3,
                                List_toBCCAddress_3,
                                contract_name,
                                contractId,
                                PIC_BA_Print,
                                Email
                            )
                        );

                        dataLengkap = false;

                        String no_surat = '';
                        String no_surat_suffix = '';
    
                        String no_surat2 = '';
                        String no_surat_suffix2 = '';

                        //------------- START SET EMAIL ADDRESS 1 -----------------------
                        Extract_Email_1_TerminationNonAutoRenewal_Setting('Email_1_1_14Hari_Setting');

                        if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toAddress_1.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toCCAddress_1.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toBCCAddress_1.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }
                        
                        if(All_contractExtension_14days_List_Extract.Account_Manager__r.Email != null){
                            Set_toAddress_1.add(All_contractExtension_14days_List_Extract.Account_Manager__r.Email);
                        }

                        if(All_Email_Head_Sales.get(All_contractExtension_14days_List_Extract.Account_Manager__r.ManagerId) != null){
                            Set_toAddress_1.add(All_Email_Head_Sales.get(All_contractExtension_14days_List_Extract.Account_Manager__r.ManagerId));
                        }

                        if(All_Email_GH_Sales.get(All_contractExtension_14days_List_Extract.Account_Manager__r.Manager_of_Manager__c) != null){
                            Set_toAddress_1.add(All_Email_GH_Sales.get(All_contractExtension_14days_List_Extract.Account_Manager__r.Manager_of_Manager__c));
                        }

                        Set_toAddress_1.remove('');
                        Set_toAddress_1.remove(null);
                        List_toAddress_1.addAll(Set_toAddress_1);

                        Set_toCCAddress_1.remove('');
                        Set_toCCAddress_1.remove(null);
                        List_toCCAddress_1.addAll(Set_toCCAddress_1);

                        Set_toBCCAddress_1.remove('');
                        Set_toBCCAddress_1.remove(null);
                        List_toBCCAddress_1.addAll(Set_toBCCAddress_1);
                        //------------- END SET EMAIL ADDRESS 1 -----------------------

                        sendEmailList.add(
                            sendEmail_1(
                                ContractExtensionid,
                                List_toAddress_1,
                                List_toCCAddress_1,
                                List_toBCCAddress_1,
                                no_surat,
                                no_surat_suffix,
                                contract_name,
                                customer_name,
                                dateValue,
                                dateValueIND,
                                dateValueEN,
                                product_name,
                                LID,
                                site_name,
                                site_name2,
                                contract_end_date,
                                contract_end_date_plus_1_hari,
                                contract_end_date_minus_14_hari,
                                contract_end_date_EN,
                                contract_end_date_plus_1_hari_EN,
                                contract_end_date_minus_14_hari_EN,
                                dataLengkap
                            )
                        );

                        sendEmailList.add(
                            sendEmail_2(
                                List_toAddress_2, 
                                List_toCCAddress_2,
                                List_toBCCAddress_2,
                                no_surat2,
                                no_surat_suffix2,
                                contract_name,
                                AM_name,
                                Head_name,
                                GH_name,
                                dateValue,
                                dateValueIND,
                                product_name,
                                LID,
                                customer_name,
                                site_name,
                                site_name2,
                                contract_end_date,
                                contract_end_date_minus_14_hari,
                                contract_end_date_plus_1_hari,
                                contract_end_date_minus_30_hari,
                                Recordlink,
                                BAP_no
                            )
                        );
                    }
                }

                /*system.debug('Set_toAddress_1 :'+ Set_toAddress_1);
                system.debug('Set_toCCAddress_1 :'+ Set_toCCAddress_1);
                system.debug('Set_toAddress_2 :'+ Set_toAddress_2);
                system.debug('Set_toCCAddress_2 :'+ Set_toCCAddress_2);*/

                system.debug('List_toAddress_1 All_contractExtension_14days_List :'+ List_toAddress_1);
                system.debug('List_toCCAddress_1 All_contractExtension_14days_List :'+ List_toCCAddress_1);
                system.debug('List_toBCCAddress_1 All_contractExtension_14days_List :'+ List_toBCCAddress_1);
                system.debug('List_toAddress_2 All_contractExtension_14days_List :'+ List_toAddress_2);
                system.debug('List_toCCAddress_2 All_contractExtension_14days_List :'+ List_toCCAddress_2);
                system.debug('List_toBCCAddress_2 All_contractExtension_14days_List :'+ List_toBCCAddress_2);

                if(List_ContractExtension_UPD!=null && !List_ContractExtension_UPD.isEmpty()){
                    system.debug('List_ContractExtension_UPD : ' + List_ContractExtension_UPD.size()) ;
                    update List_ContractExtension_UPD;   
                }
            }

            if(All_contractExtension_30days_List!=null && !All_contractExtension_30days_List.isEmpty()){
                system.debug('All_contractExtension_30days_List_SIZE : '+ All_contractExtension_30days_List.size());

                List<Contract_Extension__c> List_ContractExtension_UPD = new List<Contract_Extension__c> ();

                contractExtension_List_AccountId = new Set<Id>();
                contractExtension_List_Email_Head_Sales = new Set<Id>();
                contractExtension_List_Email_GH_Sales = new Set<Id>();

                for(Contract_Extension__c All_contractExtension_30days_List_Extract : All_contractExtension_30days_List){
                    contractExtension_List_AccountId.add(All_contractExtension_30days_List_Extract.Account__c);
                    contractExtension_List_Email_Head_Sales.add(All_contractExtension_30days_List_Extract.Account_Manager__r.ManagerId);
                    contractExtension_List_Email_GH_Sales.add(All_contractExtension_30days_List_Extract.Account_Manager__r.ManagerId);
                }

                //system.debug('contractExtension_List_AccountId 30 : ' + contractExtension_List_AccountId);

                All_Contact_PICBARecipient = getContact_PICBARecipient(contractExtension_List_AccountId);
                All_Email_Head_Sales = getHead_Sales(contractExtension_List_Email_Head_Sales);
                All_Email_GH_Sales = getGH_Sales(contractExtension_List_Email_GH_Sales);

                /*system.debug('SIZE All_Contact_PICBARecipient :'+ All_Contact_PICBARecipient.size());
                system.debug('All_Contact_PICBARecipient :'+ All_Contact_PICBARecipient.size());*/

                Extract_Email_1_TerminationNonAutoRenewal_Setting('Email_1_30Hari_Setting');
                Extract_Email_2_TerminationNonAutoRenewal_Setting('Email_2_30Hari_Setting');
                Extract_Email_3_TerminationNonAutoRenewal_Setting('Email_3_NoticeAdmin_Setting');

                Boolean dataLengkap = true;

                for(Contract_Extension__c All_contractExtension_30days_List_Extract : All_contractExtension_30days_List){
                    List_toAddress_1 = new List<string>();
                    List_toCCAddress_1 = new List<string>();
                    List_toBCCAddress_1 = new List<string>();
                    List_toAddress_2 = new List<string>();
                    List_toCCAddress_2 = new List<string>();
                    List_toBCCAddress_2 = new List<string>();
                    List_toAddress_3 = new List<string>();
                    List_toCCAddress_3 = new List<string>();
                    List_toBCCAddress_3 = new List<string>();

                    Set_toAddress_1 = new Set<string>();
                    Set_toCCAddress_1 = new Set<string>();
                    Set_toBCCAddress_1 = new Set<string>();
                    Set_toAddress_2 = new Set<string>();
                    Set_toCCAddress_2 = new Set<string>();
                    Set_toBCCAddress_2 = new Set<string>();
                    Set_toAddress_3 = new Set<string>();
                    Set_toCCAddress_3 = new Set<string>();
                    Set_toBCCAddress_3 = new Set<string>();

                    //system.debug('AccountId 30 : ' + All_contractExtension_30days_List_Extract.Account__c);

                    String ContractExtensionid = All_contractExtension_30days_List_Extract.Id;

                    //------------- START SET EMAIL ADDRESS 2 -----------------------
                    if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET.isEmpty()) {
                        Set_toAddress_2.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET);
                    }
                    
                    if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET.isEmpty()) {
                        Set_toCCAddress_2.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET);
                    }

                    if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET.isEmpty()) {
                        Set_toBCCAddress_2.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET);
                    }
                    
                    if(All_contractExtension_30days_List_Extract.Account_Manager__r.Email != null){
                        Set_toAddress_2.add(All_contractExtension_30days_List_Extract.Account_Manager__r.Email);
                    }

                    if(All_Email_Head_Sales.get(All_contractExtension_30days_List_Extract.Account_Manager__r.ManagerId) != null){
                        Set_toAddress_2.add(All_Email_Head_Sales.get(All_contractExtension_30days_List_Extract.Account_Manager__r.ManagerId));
                    }

                    if(All_Email_GH_Sales.get(All_contractExtension_30days_List_Extract.Account_Manager__r.Manager_of_Manager__c) != null){
                        Set_toAddress_2.add(All_Email_GH_Sales.get(All_contractExtension_30days_List_Extract.Account_Manager__r.Manager_of_Manager__c));
                    }

                    Set_toAddress_2.remove('');
                    Set_toAddress_2.remove(null);
                    List_toAddress_2.addAll(Set_toAddress_2);
                    
                    Set_toCCAddress_2.remove('');
                    Set_toCCAddress_2.remove(null);
                    List_toCCAddress_2.addAll(Set_toCCAddress_2);

                    Set_toBCCAddress_2.remove('');
                    Set_toBCCAddress_2.remove(null);
                    List_toBCCAddress_2.addAll(Set_toBCCAddress_2);
                    //------------- END SET EMAIL ADDRESS 2 -----------------------

                    String contract_name = All_contractExtension_30days_List_Extract.name;
                    String customer_name = All_contractExtension_30days_List_Extract.Account__r.Name;
                    //String dateValue = '30';
                    Integer dateValueINT = Integer.valueOf(All_contractExtension_30days_List_Extract.Going_To_Days__c);
                    String dateValue = String.valueOf(dateValueINT);

                    String dateValueIND = 'tiga puluh';
                    String dateValueEN = 'thirty';
                    String product_name = All_contractExtension_30days_List_Extract.Existing_Contract_item__r.Product__r.Name;
                    String LID = All_contractExtension_30days_List_Extract.Link__r.Link_ID__c;
                    String site_name = '';
                    if(String.isNotBlank(All_contractExtension_30days_List_Extract.Link__r.Site_A_Name__r.Name) && String.isNotBlank(All_contractExtension_30days_List_Extract.Link__r.Site_A_Name__r.Unique_Name__c)){
                        site_name = All_contractExtension_30days_List_Extract.Link__r.Site_A_Name__r.Name + ' ' + All_contractExtension_30days_List_Extract.Link__r.Site_A_Name__r.Unique_Name__c;
                    }else{
                        site_name = All_contractExtension_30days_List_Extract.Link__r.Site_A_Name__r.Name;
                    }

                    String site_name2 = '';
                    if(String.isNotBlank(All_contractExtension_30days_List_Extract.Link__r.Site_A_Name__r.Unique_Name__c)){
                        site_name2 = All_contractExtension_30days_List_Extract.Link__r.Site_A_Name__r.Unique_Name__c;
                    }

                    Date contract_end_date_value = All_contractExtension_30days_List_Extract.Existing_Contract_item__r.End_Date__c;
                    String contract_end_date_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_value);
                    String contract_end_date = contract_end_date_value.day() + ' ' + contract_end_date_month + ' ' + contract_end_date_value.year();
                    String contract_end_date_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_value);
                    String contract_end_date_EN = contract_end_date_value.day() + ' ' + contract_end_date_month_EN + ' ' + contract_end_date_value.year();

                    Date contract_end_date_plus_1_hari_value = All_contractExtension_30days_List_Extract.Existing_Contract_item__r.End_Date__c.addDays(1);
                    String contract_end_date_plus_1_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_plus_1_hari_value);
                    String contract_end_date_plus_1_hari = contract_end_date_plus_1_hari_value.day() + ' ' + contract_end_date_plus_1_hari_month + ' ' + contract_end_date_plus_1_hari_value.year();
                    String contract_end_date_plus_1_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_plus_1_hari_value);
                    String contract_end_date_plus_1_hari_EN = contract_end_date_plus_1_hari_value.day() + ' ' + contract_end_date_plus_1_hari_month_EN + ' ' + contract_end_date_plus_1_hari_value.year();

                    Date contract_end_date_minus_14_hari_value = All_contractExtension_30days_List_Extract.Existing_Contract_item__r.End_Date__c.addDays(-14);
                    String contract_end_date_minus_14_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_minus_14_hari_value);
                    String contract_end_date_minus_14_hari  = contract_end_date_minus_14_hari_value.day() + ' ' + contract_end_date_minus_14_hari_month + ' ' + contract_end_date_minus_14_hari_value.year();
                    String contract_end_date_minus_14_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_minus_14_hari_value);
                    String contract_end_date_minus_14_hari_EN  = contract_end_date_minus_14_hari_value.day() + ' ' + contract_end_date_minus_14_hari_month_EN + ' ' + contract_end_date_minus_14_hari_value.year();

                    Date contract_end_date_minus_30_hari_value = All_contractExtension_30days_List_Extract.Existing_Contract_item__r.End_Date__c.addDays(30);
                    String contract_end_date_minus_30_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_minus_30_hari_value);
                    String contract_end_date_minus_30_hari  = contract_end_date_minus_30_hari_value.day() + ' ' + contract_end_date_minus_30_hari_month + ' ' + contract_end_date_minus_30_hari_value.year();
                    String contract_end_date_minus_30_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_minus_30_hari_value);
                    String contract_end_date_minus_30_hari_EN  = contract_end_date_minus_30_hari_value.day() + ' ' + contract_end_date_minus_30_hari_month_EN + ' ' + contract_end_date_minus_30_hari_value.year();

                    String AM_name = All_contractExtension_30days_List_Extract.Account_Manager__r.Name;
                    String Head_name = Name_User_HeadSales.get(All_contractExtension_30days_List_Extract.Account_Manager__r.ManagerId);
                    String GH_name = Name_User_GHSales.get(All_contractExtension_30days_List_Extract.Account_Manager__r.Manager_of_Manager__c);

                    String Recordlink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+All_contractExtension_30days_List_Extract.BAP__c;
                    String BAP_no = All_contractExtension_30days_List_Extract.BAP__r.Name;
                    
                    if(
                        (
                            All_contractExtension_30days_List_Extract.BA_Print__r.Email != null || All_contractExtension_30days_List_Extract.BA_Print__c != null 
                        ) &&
                        (
                            All_contractExtension_30days_List_Extract.Status__c == 'Waiting for BA' ||
                            Test.isRunningTest()
                        )
                    ){
                        //------------- START SET EMAIL ADDRESS 1 -----------------------
                        if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toAddress_1.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toCCAddress_1.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toBCCAddress_1.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        Set_toAddress_1.add(All_contractExtension_30days_List_Extract.BA_Print__r.Email);

                        if(All_Contact_PICBARecipient.get(All_contractExtension_30days_List_Extract.Account__c) != null){
                            Set_toAddress_1.add(All_Contact_PICBARecipient.get(All_contractExtension_30days_List_Extract.Account__c));
                        }
                        
                        if(All_contractExtension_30days_List_Extract.Account_Manager__r.Email != null){
                            Set_toCCAddress_1.add(All_contractExtension_30days_List_Extract.Account_Manager__r.Email);
                        }

                        if(All_Email_Head_Sales.get(All_contractExtension_30days_List_Extract.Account_Manager__r.ManagerId) != null){
                            Set_toCCAddress_1.add(All_Email_Head_Sales.get(All_contractExtension_30days_List_Extract.Account_Manager__r.ManagerId));
                        }

                        if(All_Email_GH_Sales.get(All_contractExtension_30days_List_Extract.Account_Manager__r.Manager_of_Manager__c) != null){
                            Set_toCCAddress_1.add(All_Email_GH_Sales.get(All_contractExtension_30days_List_Extract.Account_Manager__r.Manager_of_Manager__c));
                        }

                        Set_toAddress_1.remove('');
                        Set_toAddress_1.remove(null);
                        List_toAddress_1.addAll(Set_toAddress_1);

                        Set_toCCAddress_1.remove('');
                        Set_toCCAddress_1.remove(null);
                        List_toCCAddress_1.addAll(Set_toCCAddress_1);

                        Set_toBCCAddress_1.remove('');
                        Set_toBCCAddress_1.remove(null);
                        List_toBCCAddress_1.addAll(Set_toBCCAddress_1);
                        //------------- END SET EMAIL ADDRESS 1 -----------------------

                        Integer no_suratCount = 0 + 1;
                        If(All_contractExtension_30days_List_Extract.Email_Tenar_Count__c != null){
                            no_suratCount = Integer.ValueOf(All_contractExtension_30days_List_Extract.Email_Tenar_Count__c) + 1;
                        }

                        All_contractExtension_30days_List_Extract.Email_Tenar_Count__c = no_suratCount;
                        List_ContractExtension_UPD.add(All_contractExtension_30days_List_Extract);

                        String no_surat = String.ValueOf(no_suratCount);
                        String no_surat_suffix = appUtils.getNumberSuffix(Integer.ValueOf(no_surat));

                        String no_surat2 = '';
                        String no_surat_suffix2 = '';

                        sendEmailList.add(
                            sendEmail_1(
                                ContractExtensionid,
                                List_toAddress_1,
                                List_toCCAddress_1,
                                List_toBCCAddress_1,
                                no_surat,
                                no_surat_suffix,
                                contract_name,
                                customer_name,
                                dateValue,
                                dateValueIND,
                                dateValueEN,
                                product_name,
                                LID,
                                site_name,
                                site_name2,
                                contract_end_date,
                                contract_end_date_plus_1_hari,
                                contract_end_date_minus_14_hari,
                                contract_end_date_EN,
                                contract_end_date_plus_1_hari_EN,
                                contract_end_date_minus_14_hari_EN,
                                dataLengkap
                            )
                        );

                        sendEmailList.add(
                            sendEmail_2(
                                List_toAddress_2, 
                                List_toCCAddress_2,
                                List_toBCCAddress_2,
                                no_surat2,
                                no_surat_suffix2,
                                contract_name,
                                AM_name,
                                Head_name,
                                GH_name,
                                dateValue,
                                dateValueIND,
                                product_name,
                                LID,
                                customer_name,
                                site_name,
                                site_name2,
                                contract_end_date,
                                contract_end_date_minus_14_hari,
                                contract_end_date_plus_1_hari,
                                contract_end_date_minus_30_hari,
                                Recordlink,
                                BAP_no
                            )
                        );
                    }else{
                        Set_toAddress_3.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);
                        Set_toCCAddress_3.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);
                        Set_toBCCAddress_3.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);

                        List_toAddress_3.addAll(Set_toAddress_3);
                        List_toCCAddress_3.addAll(Set_toCCAddress_3);
                        List_toBCCAddress_3.addAll(Set_toBCCAddress_3);

                        String contractId = All_contractExtension_30days_List_Extract.id;
                        String PIC_BA_Print = All_contractExtension_30days_List_Extract.BA_Print__r.Name;
                        String Email = All_contractExtension_30days_List_Extract.BA_Print__r.email;

                        sendEmailList.add(
                            sendEmail_3(
                                List_toAddress_3, 
                                List_toCCAddress_3,
                                List_toBCCAddress_3,
                                contract_name,
                                contractId,
                                PIC_BA_Print,
                                Email
                            )
                        );

                        dataLengkap = false;

                        String no_surat = '';
                        String no_surat_suffix = '';
    
                        String no_surat2 = '';
                        String no_surat_suffix2 = '';

                        //------------- START SET EMAIL ADDRESS 1 -----------------------
                        Extract_Email_1_TerminationNonAutoRenewal_Setting('Email_1_1_30Hari_Setting');

                        if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toAddress_1.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toCCAddress_1.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toBCCAddress_1.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }
                        
                        if(All_contractExtension_30days_List_Extract.Account_Manager__r.Email != null){
                            Set_toAddress_1.add(All_contractExtension_30days_List_Extract.Account_Manager__r.Email);
                        }

                        if(All_Email_Head_Sales.get(All_contractExtension_30days_List_Extract.Account_Manager__r.ManagerId) != null){
                            Set_toAddress_1.add(All_Email_Head_Sales.get(All_contractExtension_30days_List_Extract.Account_Manager__r.ManagerId));
                        }

                        if(All_Email_GH_Sales.get(All_contractExtension_30days_List_Extract.Account_Manager__r.Manager_of_Manager__c) != null){
                            Set_toAddress_1.add(All_Email_GH_Sales.get(All_contractExtension_30days_List_Extract.Account_Manager__r.Manager_of_Manager__c));
                        }

                        Set_toAddress_1.remove('');
                        Set_toAddress_1.remove(null);
                        List_toAddress_1.addAll(Set_toAddress_1);

                        Set_toCCAddress_1.remove('');
                        Set_toCCAddress_1.remove(null);
                        List_toCCAddress_1.addAll(Set_toCCAddress_1);

                        Set_toBCCAddress_1.remove('');
                        Set_toBCCAddress_1.remove(null);
                        List_toBCCAddress_1.addAll(Set_toBCCAddress_1);
                        //------------- END SET EMAIL ADDRESS 1 -----------------------

                        sendEmailList.add(
                            sendEmail_1(
                                ContractExtensionid,
                                List_toAddress_1,
                                List_toCCAddress_1,
                                List_toBCCAddress_1,
                                no_surat,
                                no_surat_suffix,
                                contract_name,
                                customer_name,
                                dateValue,
                                dateValueIND,
                                dateValueEN,
                                product_name,
                                LID,
                                site_name,
                                site_name2,
                                contract_end_date,
                                contract_end_date_plus_1_hari,
                                contract_end_date_minus_14_hari,
                                contract_end_date_EN,
                                contract_end_date_plus_1_hari_EN,
                                contract_end_date_minus_14_hari_EN,
                                dataLengkap
                            )
                        );

                        sendEmailList.add(
                            sendEmail_2(
                                List_toAddress_2, 
                                List_toCCAddress_2,
                                List_toBCCAddress_2,
                                no_surat2,
                                no_surat_suffix2,
                                contract_name,
                                AM_name,
                                Head_name,
                                GH_name,
                                dateValue,
                                dateValueIND,
                                product_name,
                                LID,
                                customer_name,
                                site_name,
                                site_name2,
                                contract_end_date,
                                contract_end_date_minus_14_hari,
                                contract_end_date_plus_1_hari,
                                contract_end_date_minus_30_hari,
                                Recordlink,
                                BAP_no
                            )
                        );
                    }
                }

                /*system.debug('Set_toAddress_1 :'+ Set_toAddress_1);
                system.debug('Set_toCCAddress_1 :'+ Set_toCCAddress_1);
                system.debug('Set_toAddress_2 :'+ Set_toAddress_2);
                system.debug('Set_toCCAddress_2 :'+ Set_toCCAddress_2);*/

                system.debug('List_toAddress_1 All_contractExtension_30days_List :'+ List_toAddress_1);
                system.debug('List_toCCAddress_1 All_contractExtension_30days_List :'+ List_toCCAddress_1);
                system.debug('List_toBCCAddress_1 All_contractExtension_30days_List :'+ List_toBCCAddress_1);
                system.debug('List_toAddress_2 All_contractExtension_30days_List :'+ List_toAddress_2);
                system.debug('List_toCCAddress_2 All_contractExtension_30days_List :'+ List_toCCAddress_2);
                system.debug('List_toBCCAddress_2 All_contractExtension_30days_List :'+ List_toBCCAddress_2);

                if(List_ContractExtension_UPD!=null && !List_ContractExtension_UPD.isEmpty()){
                    system.debug('List_ContractExtension_UPD : ' + List_ContractExtension_UPD.size()) ;
                    update List_ContractExtension_UPD;   
                }
            }

            if(All_contractExtension_60days_List!=null && !All_contractExtension_60days_List.isEmpty()){
                system.debug('All_contractExtension_60days_List_SIZE : '+ All_contractExtension_60days_List.size());

                List<Contract_Extension__c> List_ContractExtension_UPD = new List<Contract_Extension__c> ();
                
                contractExtension_List_AccountId = new Set<Id>();
                contractExtension_List_Email_Head_Sales = new Set<Id>();
                contractExtension_List_Email_GH_Sales = new Set<Id>();

                for(Contract_Extension__c All_contractExtension_60days_ListExtract : All_contractExtension_60days_List){
                    contractExtension_List_AccountId.add(All_contractExtension_60days_ListExtract.Account__c);
                    contractExtension_List_Email_Head_Sales.add(All_contractExtension_60days_ListExtract.Account_Manager__r.ManagerId);
                    contractExtension_List_Email_GH_Sales.add(All_contractExtension_60days_ListExtract.Account_Manager__r.ManagerId);
                }

                All_Contact_PICBARecipient = getContact_PICBARecipient(contractExtension_List_AccountId);
                All_Email_Head_Sales = getHead_Sales(contractExtension_List_Email_Head_Sales);
                All_Email_GH_Sales = getGH_Sales(contractExtension_List_Email_GH_Sales);

                /*system.debug('SIZE All_Contact_PICBARecipient :'+ All_Contact_PICBARecipient.size());
                system.debug('All_Contact_PICBARecipient :'+ All_Contact_PICBARecipient.size());*/

                Extract_Email_1_TerminationNonAutoRenewal_Setting('Email_1_60Hari_Setting');
                Extract_Email_3_TerminationNonAutoRenewal_Setting('Email_3_NoticeAdmin_Setting');

                Boolean dataLengkap = true;

                for(Contract_Extension__c All_contractExtension_60days_ListExtract : All_contractExtension_60days_List){
                    List_toAddress_1 = new List<string>();
                    List_toCCAddress_1 = new List<string>();
                    List_toBCCAddress_1 = new List<string>();
                    List_toAddress_2 = new List<string>();
                    List_toCCAddress_2 = new List<string>();
                    List_toBCCAddress_2 = new List<string>();
                    List_toAddress_3 = new List<string>();
                    List_toCCAddress_3 = new List<string>();
                    List_toBCCAddress_3 = new List<string>();

                    Set_toAddress_1 = new Set<string>();
                    Set_toCCAddress_1 = new Set<string>();
                    Set_toBCCAddress_1 = new Set<string>();
                    Set_toAddress_2 = new Set<string>();
                    Set_toCCAddress_2 = new Set<string>();
                    Set_toBCCAddress_2 = new Set<string>();
                    Set_toAddress_3 = new Set<string>();
                    Set_toCCAddress_3 = new Set<string>();
                    Set_toBCCAddress_3 = new Set<string>();

                    String ContractExtensionid = All_contractExtension_60days_ListExtract.Id;

                    String contract_name = All_contractExtension_60days_ListExtract.name;
                    String customer_name = All_contractExtension_60days_ListExtract.Account__r.Name;
                    //String dateValue = '60';
                    Integer dateValueINT = Integer.valueOf(All_contractExtension_60days_ListExtract.Going_To_Days__c);
                    String dateValue = String.valueOf(dateValueINT);

                    String dateValueIND = 'enam puluh';
                    String dateValueEN = 'sixty';
                    String product_name = All_contractExtension_60days_ListExtract.Existing_Contract_item__r.Product__r.Name;
                    String LID = All_contractExtension_60days_ListExtract.Link__r.Link_ID__c;
                    String site_name = '';
                    if(String.isNotBlank(All_contractExtension_60days_ListExtract.Link__r.Site_A_Name__r.Name) && String.isNotBlank(All_contractExtension_60days_ListExtract.Link__r.Site_A_Name__r.Unique_Name__c)){
                        site_name = All_contractExtension_60days_ListExtract.Link__r.Site_A_Name__r.Name + ' ' + All_contractExtension_60days_ListExtract.Link__r.Site_A_Name__r.Unique_Name__c;
                    }else{
                        site_name = All_contractExtension_60days_ListExtract.Link__r.Site_A_Name__r.Name;
                    }

                    String site_name2 = '';
                    if(String.isNotBlank(All_contractExtension_60days_ListExtract.Link__r.Site_A_Name__r.Unique_Name__c)){
                        site_name2 = All_contractExtension_60days_ListExtract.Link__r.Site_A_Name__r.Unique_Name__c;
                    }

                    Date contract_end_date_value = All_contractExtension_60days_ListExtract.Existing_Contract_item__r.End_Date__c;
                    String contract_end_date_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_value);
                    String contract_end_date = contract_end_date_value.day() + ' ' + contract_end_date_month + ' ' + contract_end_date_value.year();
                    String contract_end_date_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_value);
                    String contract_end_date_EN = contract_end_date_value.day() + ' ' + contract_end_date_month_EN + ' ' + contract_end_date_value.year();

                    Date contract_end_date_plus_1_hari_value = All_contractExtension_60days_ListExtract.Existing_Contract_item__r.End_Date__c.addDays(1);
                    String contract_end_date_plus_1_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_plus_1_hari_value);
                    String contract_end_date_plus_1_hari = contract_end_date_plus_1_hari_value.day() + ' ' + contract_end_date_plus_1_hari_month + ' ' + contract_end_date_plus_1_hari_value.year();
                    String contract_end_date_plus_1_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_plus_1_hari_value);
                    String contract_end_date_plus_1_hari_EN = contract_end_date_plus_1_hari_value.day() + ' ' + contract_end_date_plus_1_hari_month_EN + ' ' + contract_end_date_plus_1_hari_value.year();

                    Date contract_end_date_minus_14_hari_value = All_contractExtension_60days_ListExtract.Existing_Contract_item__r.End_Date__c.addDays(-14);
                    String contract_end_date_minus_14_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_minus_14_hari_value);
                    String contract_end_date_minus_14_hari  = contract_end_date_minus_14_hari_value.day() + ' ' + contract_end_date_minus_14_hari_month + ' ' + contract_end_date_minus_14_hari_value.year();
                    String contract_end_date_minus_14_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_minus_14_hari_value);
                    String contract_end_date_minus_14_hari_EN  = contract_end_date_minus_14_hari_value.day() + ' ' + contract_end_date_minus_14_hari_month_EN + ' ' + contract_end_date_minus_14_hari_value.year();

                    Date contract_end_date_minus_60_hari_value = All_contractExtension_60days_ListExtract.Existing_Contract_item__r.End_Date__c.addDays(60);
                    String contract_end_date_minus_60_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_minus_60_hari_value);
                    String contract_end_date_minus_60_hari  = contract_end_date_minus_60_hari_value.day() + ' ' + contract_end_date_minus_60_hari_month + ' ' + contract_end_date_minus_60_hari_value.year();
                    String contract_end_date_minus_60_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_minus_60_hari_value);
                    String contract_end_date_minus_60_hari_EN  = contract_end_date_minus_60_hari_value.day() + ' ' + contract_end_date_minus_60_hari_month_EN + ' ' + contract_end_date_minus_60_hari_value.year();

                    String AM_name = All_contractExtension_60days_ListExtract.Account_Manager__r.Name;
                    String Head_name = Name_User_HeadSales.get(All_contractExtension_60days_ListExtract.Account_Manager__r.ManagerId);
                    String GH_name = Name_User_GHSales.get(All_contractExtension_60days_ListExtract.Account_Manager__r.Manager_of_Manager__c);

                    String Recordlink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+All_contractExtension_60days_ListExtract.BAP__c;
                    String BAP_no = All_contractExtension_60days_ListExtract.BAP__r.Name;

                    if(
                        (
                            All_contractExtension_60days_ListExtract.BA_Print__r.Email != null || All_contractExtension_60days_ListExtract.BA_Print__c != null 
                        ) &&
                        (
                            All_contractExtension_60days_ListExtract.Status__c == 'Waiting for BA' ||
                            Test.isRunningTest()
                        )
                    ){
                        //------------- START SET EMAIL ADDRESS 1 -----------------------
                        if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toAddress_1.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toCCAddress_1.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toBCCAddress_1.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }
                        
                        Set_toAddress_1.add(All_contractExtension_60days_ListExtract.BA_Print__r.Email);

                        if(All_Contact_PICBARecipient.get(All_contractExtension_60days_ListExtract.Account__c) != null){
                            Set_toAddress_1.add(All_Contact_PICBARecipient.get(All_contractExtension_60days_ListExtract.Account__c));
                        }
                        
                        if(All_contractExtension_60days_ListExtract.Account_Manager__r.Email != null){
                            Set_toCCAddress_1.add(All_contractExtension_60days_ListExtract.Account_Manager__r.Email);
                        }

                        if(All_Email_Head_Sales.get(All_contractExtension_60days_ListExtract.Account_Manager__r.ManagerId) != null){
                            Set_toCCAddress_1.add(All_Email_Head_Sales.get(All_contractExtension_60days_ListExtract.Account_Manager__r.ManagerId));
                        }

                        if(All_Email_GH_Sales.get(All_contractExtension_60days_ListExtract.Account_Manager__r.Manager_of_Manager__c) != null){
                            Set_toCCAddress_1.add(All_Email_GH_Sales.get(All_contractExtension_60days_ListExtract.Account_Manager__r.Manager_of_Manager__c));
                        }

                        Set_toAddress_1.remove('');
                        Set_toAddress_1.remove(null);
                        List_toAddress_1.addAll(Set_toAddress_1);

                        Set_toCCAddress_1.remove('');
                        Set_toCCAddress_1.remove(null);
                        List_toCCAddress_1.addAll(Set_toCCAddress_1);

                        Set_toBCCAddress_1.remove('');
                        Set_toBCCAddress_1.remove(null);
                        List_toBCCAddress_1.addAll(Set_toBCCAddress_1);
                        //------------- END SET EMAIL ADDRESS 1 -----------------------

                        Integer no_suratCount = 0 + 1;

                        If(All_contractExtension_60days_ListExtract.Email_Tenar_Count__c != null){
                            no_suratCount = Integer.ValueOf(All_contractExtension_60days_ListExtract.Email_Tenar_Count__c) + 1;
                        }

                        All_contractExtension_60days_ListExtract.Email_Tenar_Count__c = no_suratCount;
                        List_ContractExtension_UPD.add(All_contractExtension_60days_ListExtract);

                        String no_surat = String.ValueOf(no_suratCount);
                        String no_surat_suffix = appUtils.getNumberSuffix(Integer.ValueOf(no_surat));

                        String no_surat2 = '';
                        String no_surat_suffix2 = '';


                        sendEmailList.add(
                            sendEmail_1(
                                ContractExtensionid,
                                List_toAddress_1,
                                List_toCCAddress_1,
                                List_toBCCAddress_1,
                                no_surat,
                                no_surat_suffix,
                                contract_name,
                                customer_name,
                                dateValue,
                                dateValueIND,
                                dateValueEN,
                                product_name,
                                LID,
                                site_name,
                                site_name2,
                                contract_end_date,
                                contract_end_date_plus_1_hari,
                                contract_end_date_minus_14_hari,
                                contract_end_date_EN,
                                contract_end_date_plus_1_hari_EN,
                                contract_end_date_minus_14_hari_EN,
                                dataLengkap
                            )
                        );
                    }else{
                        Set_toAddress_3.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);
                        Set_toCCAddress_3.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);
                        Set_toBCCAddress_3.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);

                        List_toAddress_3.addAll(Set_toAddress_3);
                        List_toCCAddress_3.addAll(Set_toCCAddress_3);
                        List_toBCCAddress_3.addAll(Set_toBCCAddress_3);

                        String contractId = All_contractExtension_60days_ListExtract.id;
                        String PIC_BA_Print = All_contractExtension_60days_ListExtract.BA_Print__r.Name;
                        String Email = All_contractExtension_60days_ListExtract.BA_Print__r.email;

                        sendEmailList.add(
                            sendEmail_3(
                                List_toAddress_3, 
                                List_toCCAddress_3,
                                List_toBCCAddress_3,
                                contract_name,
                                contractId,
                                PIC_BA_Print,
                                Email
                            )
                        );

                        dataLengkap = false;

                        String no_surat = '';
                        String no_surat_suffix = '';
    
                        String no_surat2 = '';
                        String no_surat_suffix2 = '';

                        //------------- START SET EMAIL ADDRESS 1 -----------------------
                        Extract_Email_1_TerminationNonAutoRenewal_Setting('Email_1_1_60Hari_Setting');

                        if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toAddress_1.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toCCAddress_1.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toBCCAddress_1.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }
                        
                        if(All_contractExtension_60days_ListExtract.Account_Manager__r.Email != null){
                            Set_toAddress_1.add(All_contractExtension_60days_ListExtract.Account_Manager__r.Email);
                        }

                        if(All_Email_Head_Sales.get(All_contractExtension_60days_ListExtract.Account_Manager__r.ManagerId) != null){
                            Set_toAddress_1.add(All_Email_Head_Sales.get(All_contractExtension_60days_ListExtract.Account_Manager__r.ManagerId));
                        }

                        if(All_Email_GH_Sales.get(All_contractExtension_60days_ListExtract.Account_Manager__r.Manager_of_Manager__c) != null){
                            Set_toAddress_1.add(All_Email_GH_Sales.get(All_contractExtension_60days_ListExtract.Account_Manager__r.Manager_of_Manager__c));
                        }

                        Set_toAddress_1.remove('');
                        Set_toAddress_1.remove(null);
                        List_toAddress_1.addAll(Set_toAddress_1);

                        Set_toCCAddress_1.remove('');
                        Set_toCCAddress_1.remove(null);
                        List_toCCAddress_1.addAll(Set_toCCAddress_1);

                        Set_toBCCAddress_1.remove('');
                        Set_toBCCAddress_1.remove(null);
                        List_toBCCAddress_1.addAll(Set_toBCCAddress_1);
                        //------------- END SET EMAIL ADDRESS 1 -----------------------

                        sendEmailList.add(
                            sendEmail_1(
                                ContractExtensionid,
                                List_toAddress_1,
                                List_toCCAddress_1,
                                List_toBCCAddress_1,
                                no_surat,
                                no_surat_suffix,
                                contract_name,
                                customer_name,
                                dateValue,
                                dateValueIND,
                                dateValueEN,
                                product_name,
                                LID,
                                site_name,
                                site_name2,
                                contract_end_date,
                                contract_end_date_plus_1_hari,
                                contract_end_date_minus_14_hari,
                                contract_end_date_EN,
                                contract_end_date_plus_1_hari_EN,
                                contract_end_date_minus_14_hari_EN,
                                dataLengkap
                            )
                        );
                    }
                }

                /*system.debug('Set_toAddress_1 :'+ Set_toAddress_1);
                system.debug('Set_toCCAddress_1 :'+ Set_toCCAddress_1);
                system.debug('Set_toAddress_2 :'+ Set_toAddress_2);
                system.debug('Set_toCCAddress_2 :'+ Set_toCCAddress_2);*/

                system.debug('List_toAddress_1 All_contractExtension_60days_List :'+ List_toAddress_1);
                system.debug('List_toCCAddress_1 All_contractExtension_60days_List :'+ List_toCCAddress_1);
                system.debug('List_toBCCAddress_1 All_contractExtension_60days_List :'+ List_toBCCAddress_1);

                if(List_ContractExtension_UPD!=null && !List_ContractExtension_UPD.isEmpty()){
                    system.debug('List_ContractExtension_UPD : ' + List_ContractExtension_UPD.size()) ;
                    update List_ContractExtension_UPD;   
                }
            }

            if(All_contractExtension_90days_List!=null && !All_contractExtension_90days_List.isEmpty()){
                system.debug('All_contractExtension_90days_List_SIZE : '+ All_contractExtension_90days_List.size());

                List<Contract_Extension__c> List_ContractExtension_UPD = new List<Contract_Extension__c> ();

                contractExtension_List_AccountId = new Set<Id>();
                contractExtension_List_Email_Head_Sales = new Set<Id>();
                contractExtension_List_Email_GH_Sales = new Set<Id>();

                for(Contract_Extension__c All_contractExtension_90days_ListExtract : All_contractExtension_90days_List){
                    contractExtension_List_AccountId.add(All_contractExtension_90days_ListExtract.Account__c);
                    contractExtension_List_Email_Head_Sales.add(All_contractExtension_90days_ListExtract.Account_Manager__r.ManagerId);
                    contractExtension_List_Email_GH_Sales.add(All_contractExtension_90days_ListExtract.Account_Manager__r.ManagerId);
                }

                All_Contact_PICBARecipient = getContact_PICBARecipient(contractExtension_List_AccountId);
                All_Email_Head_Sales = getHead_Sales(contractExtension_List_Email_Head_Sales);
                All_Email_GH_Sales = getGH_Sales(contractExtension_List_Email_GH_Sales);

                /*system.debug('SIZE All_Contact_PICBARecipient :'+ All_Contact_PICBARecipient.size());
                system.debug('All_Contact_PICBARecipient :'+ All_Contact_PICBARecipient);*/

                Extract_Email_1_TerminationNonAutoRenewal_Setting('Email_1_90Hari_Setting');
                Extract_Email_3_TerminationNonAutoRenewal_Setting('Email_3_NoticeAdmin_Setting');

                Boolean dataLengkap = true;

                for(Contract_Extension__c All_contractExtension_90days_ListExtract : All_contractExtension_90days_List){
                    List_toAddress_1 = new List<string>();
                    List_toCCAddress_1 = new List<string>();
                    List_toBCCAddress_1 = new List<string>();
                    List_toAddress_2 = new List<string>();
                    List_toCCAddress_2 = new List<string>();
                    List_toBCCAddress_2 = new List<string>();
                    List_toAddress_3 = new List<string>();
                    List_toCCAddress_3 = new List<string>();
                    List_toBCCAddress_3 = new List<string>();

                    Set_toAddress_1 = new Set<string>();
                    Set_toCCAddress_1 = new Set<string>();
                    Set_toBCCAddress_1 = new Set<string>();
                    Set_toAddress_2 = new Set<string>();
                    Set_toCCAddress_2 = new Set<string>();
                    Set_toBCCAddress_2 = new Set<string>();
                    Set_toAddress_3 = new Set<string>();
                    Set_toCCAddress_3 = new Set<string>();
                    Set_toBCCAddress_3 = new Set<string>();

                    String ContractExtensionid = All_contractExtension_90days_ListExtract.Id;

                    String contract_name = All_contractExtension_90days_ListExtract.name;
                    String customer_name = All_contractExtension_90days_ListExtract.Account__r.Name;
                    //String dateValue = '90';
                    Integer dateValueINT = Integer.valueOf(All_contractExtension_90days_ListExtract.Going_To_Days__c);
                    String dateValue = String.valueOf(dateValueINT);

                    String dateValueIND = 'sembilan puluh';
                    String dateValueEN = 'ninety';
                    String product_name = All_contractExtension_90days_ListExtract.Existing_Contract_item__r.Product__r.Name;
                    String LID = All_contractExtension_90days_ListExtract.Link__r.Link_ID__c;
                    String site_name = '';
                    if(String.isNotBlank(All_contractExtension_90days_ListExtract.Link__r.Site_A_Name__r.Name) && String.isNotBlank(All_contractExtension_90days_ListExtract.Link__r.Site_A_Name__r.Unique_Name__c)){
                        site_name = All_contractExtension_90days_ListExtract.Link__r.Site_A_Name__r.Name + ' ' + All_contractExtension_90days_ListExtract.Link__r.Site_A_Name__r.Unique_Name__c;
                    }else{
                        site_name = All_contractExtension_90days_ListExtract.Link__r.Site_A_Name__r.Name;
                    }

                    String site_name2 = '';
                    if(String.isNotBlank(All_contractExtension_90days_ListExtract.Link__r.Site_A_Name__r.Unique_Name__c)){
                        site_name2 = All_contractExtension_90days_ListExtract.Link__r.Site_A_Name__r.Unique_Name__c;
                    }

                    Date contract_end_date_value = All_contractExtension_90days_ListExtract.Existing_Contract_item__r.End_Date__c;
                    String contract_end_date_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_value);
                    String contract_end_date = contract_end_date_value.day() + ' ' + contract_end_date_month + ' ' + contract_end_date_value.year();
                    String contract_end_date_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_value);
                    String contract_end_date_EN = contract_end_date_value.day() + ' ' + contract_end_date_month_EN + ' ' + contract_end_date_value.year();

                    Date contract_end_date_plus_1_hari_value = All_contractExtension_90days_ListExtract.Existing_Contract_item__r.End_Date__c.addDays(1);
                    String contract_end_date_plus_1_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_plus_1_hari_value);
                    String contract_end_date_plus_1_hari = contract_end_date_plus_1_hari_value.day() + ' ' + contract_end_date_plus_1_hari_month + ' ' + contract_end_date_plus_1_hari_value.year();
                    String contract_end_date_plus_1_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_plus_1_hari_value);
                    String contract_end_date_plus_1_hari_EN = contract_end_date_plus_1_hari_value.day() + ' ' + contract_end_date_plus_1_hari_month_EN + ' ' + contract_end_date_plus_1_hari_value.year();

                    Date contract_end_date_minus_14_hari_value = All_contractExtension_90days_ListExtract.Existing_Contract_item__r.End_Date__c.addDays(-14);
                    String contract_end_date_minus_14_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_minus_14_hari_value);
                    String contract_end_date_minus_14_hari  = contract_end_date_minus_14_hari_value.day() + ' ' + contract_end_date_minus_14_hari_month + ' ' + contract_end_date_minus_14_hari_value.year();
                    String contract_end_date_minus_14_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_minus_14_hari_value);
                    String contract_end_date_minus_14_hari_EN  = contract_end_date_minus_14_hari_value.day() + ' ' + contract_end_date_minus_14_hari_month_EN + ' ' + contract_end_date_minus_14_hari_value.year();

                    Date contract_end_date_minus_90_hari_value = All_contractExtension_90days_ListExtract.Existing_Contract_item__r.End_Date__c.addDays(90);
                    String contract_end_date_minus_90_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_minus_90_hari_value);
                    String contract_end_date_minus_90_hari  = contract_end_date_minus_90_hari_value.day() + ' ' + contract_end_date_minus_90_hari_month + ' ' + contract_end_date_minus_90_hari_value.year();
                    String contract_end_date_minus_90_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_minus_90_hari_value);
                    String contract_end_date_minus_90_hari_EN  = contract_end_date_minus_90_hari_value.day() + ' ' + contract_end_date_minus_90_hari_month_EN + ' ' + contract_end_date_minus_90_hari_value.year();

                    String AM_name = All_contractExtension_90days_ListExtract.Account_Manager__r.Name;
                    String Head_name = Name_User_HeadSales.get(All_contractExtension_90days_ListExtract.Account_Manager__r.ManagerId);
                    String GH_name = Name_User_GHSales.get(All_contractExtension_90days_ListExtract.Account_Manager__r.Manager_of_Manager__c);

                    String Recordlink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+All_contractExtension_90days_ListExtract.BAP__c;
                    String BAP_no = All_contractExtension_90days_ListExtract.BAP__r.Name;

                    if(
                        (
                            All_contractExtension_90days_ListExtract.BA_Print__r.Email != null || All_contractExtension_90days_ListExtract.BA_Print__c != null 
                        ) &&
                        (
                            All_contractExtension_90days_ListExtract.Status__c == 'Waiting for BA' ||
                            Test.isRunningTest()
                        )
                    ){
                        //------------- START SET EMAIL ADDRESS 1 -----------------------
                        if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toAddress_1.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toCCAddress_1.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toBCCAddress_1.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        Set_toAddress_1.add(All_contractExtension_90days_ListExtract.BA_Print__r.Email);

                        if(All_Contact_PICBARecipient.get(All_contractExtension_90days_ListExtract.Account__c) != null){
                            Set_toAddress_1.add(All_Contact_PICBARecipient.get(All_contractExtension_90days_ListExtract.Account__c));
                        }
                        
                        if(All_contractExtension_90days_ListExtract.Account_Manager__r.Email != null){
                            Set_toCCAddress_1.add(All_contractExtension_90days_ListExtract.Account_Manager__r.Email);
                        }

                        if(All_Email_Head_Sales.get(All_contractExtension_90days_ListExtract.Account_Manager__r.ManagerId) != null){
                            Set_toCCAddress_1.add(All_Email_Head_Sales.get(All_contractExtension_90days_ListExtract.Account_Manager__r.ManagerId));
                        }

                        if(All_Email_GH_Sales.get(All_contractExtension_90days_ListExtract.Account_Manager__r.Manager_of_Manager__c) != null){
                            Set_toCCAddress_1.add(All_Email_GH_Sales.get(All_contractExtension_90days_ListExtract.Account_Manager__r.Manager_of_Manager__c));
                        }

                        Set_toAddress_1.remove('');
                        Set_toAddress_1.remove(null);
                        List_toAddress_1.addAll(Set_toAddress_1);
                        
                        Set_toCCAddress_1.remove('');
                        Set_toCCAddress_1.remove(null);
                        List_toCCAddress_1.addAll(Set_toCCAddress_1);

                        Set_toBCCAddress_1.remove('');
                        Set_toBCCAddress_1.remove(null);
                        List_toBCCAddress_1.addAll(Set_toBCCAddress_1);
                        //------------- END SET EMAIL ADDRESS 1 -----------------------

                        Integer no_suratCount = 0 + 1;

                        If(All_contractExtension_90days_ListExtract.Email_Tenar_Count__c != null){
                            no_suratCount = Integer.ValueOf(All_contractExtension_90days_ListExtract.Email_Tenar_Count__c) + 1;
                        }

                        All_contractExtension_90days_ListExtract.Email_Tenar_Count__c = no_suratCount;
                        List_ContractExtension_UPD.add(All_contractExtension_90days_ListExtract);

                        String no_surat = String.ValueOf(no_suratCount);
                        String no_surat_suffix = appUtils.getNumberSuffix(Integer.ValueOf(no_surat));

                        String no_surat2 = '';
                        String no_surat_suffix2 = '';

                        sendEmailList.add(
                            sendEmail_1(
                                ContractExtensionid,
                                List_toAddress_1,
                                List_toCCAddress_1,
                                List_toBCCAddress_1,
                                no_surat,
                                no_surat_suffix,
                                contract_name,
                                customer_name,
                                dateValue,
                                dateValueIND,
                                dateValueEN,
                                product_name,
                                LID,
                                site_name,
                                site_name2,
                                contract_end_date,
                                contract_end_date_plus_1_hari,
                                contract_end_date_minus_14_hari,
                                contract_end_date_EN,
                                contract_end_date_plus_1_hari_EN,
                                contract_end_date_minus_14_hari_EN,
                                dataLengkap
                            )
                        );
                    }else{
                        Set_toAddress_3.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);
                        Set_toCCAddress_3.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);
                        Set_toBCCAddress_3.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);

                        List_toAddress_3.addAll(Set_toAddress_3);
                        List_toCCAddress_3.addAll(Set_toCCAddress_3);
                        List_toBCCAddress_3.addAll(Set_toBCCAddress_3);

                        String contractId = All_contractExtension_90days_ListExtract.id;
                        String PIC_BA_Print = All_contractExtension_90days_ListExtract.BA_Print__r.Name;
                        String Email = All_contractExtension_90days_ListExtract.BA_Print__r.email;

                        sendEmailList.add(
                            sendEmail_3(
                                List_toAddress_3, 
                                List_toCCAddress_3,
                                List_toBCCAddress_3,
                                contract_name,
                                contractId,
                                PIC_BA_Print,
                                Email
                            )
                        );

                        dataLengkap = false;

                        String no_surat = '';
                        String no_surat_suffix = '';
    
                        String no_surat2 = '';
                        String no_surat_suffix2 = '';

                        //------------- START SET EMAIL ADDRESS 1 -----------------------
                        Extract_Email_1_TerminationNonAutoRenewal_Setting('Email_1_1_90Hari_Setting');

                        if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toAddress_1.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toCCAddress_1.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toBCCAddress_1.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.isEmpty()) {
                            Set_toBCCAddress_1.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        }

                        if(All_contractExtension_90days_ListExtract.Account_Manager__r.Email != null){
                            Set_toAddress_1.add(All_contractExtension_90days_ListExtract.Account_Manager__r.Email);
                        }

                        if(All_Email_Head_Sales.get(All_contractExtension_90days_ListExtract.Account_Manager__r.ManagerId) != null){
                            Set_toAddress_1.add(All_Email_Head_Sales.get(All_contractExtension_90days_ListExtract.Account_Manager__r.ManagerId));
                        }

                        if(All_Email_GH_Sales.get(All_contractExtension_90days_ListExtract.Account_Manager__r.Manager_of_Manager__c) != null){
                            Set_toAddress_1.add(All_Email_GH_Sales.get(All_contractExtension_90days_ListExtract.Account_Manager__r.Manager_of_Manager__c));
                        }

                        Set_toAddress_1.remove('');
                        Set_toAddress_1.remove(null);
                        List_toAddress_1.addAll(Set_toAddress_1);
                        
                        Set_toCCAddress_1.remove('');
                        Set_toCCAddress_1.remove(null);
                        List_toCCAddress_1.addAll(Set_toCCAddress_1);

                        Set_toBCCAddress_1.remove('');
                        Set_toBCCAddress_1.remove(null);
                        List_toBCCAddress_1.addAll(Set_toBCCAddress_1);
                        //------------- END SET EMAIL ADDRESS 1 -----------------------

                        sendEmailList.add(
                            sendEmail_1(
                                ContractExtensionid,
                                List_toAddress_1,
                                List_toCCAddress_1,
                                List_toBCCAddress_1,
                                no_surat,
                                no_surat_suffix,
                                contract_name,
                                customer_name,
                                dateValue,
                                dateValueIND,
                                dateValueEN,
                                product_name,
                                LID,
                                site_name,
                                site_name2,
                                contract_end_date,
                                contract_end_date_plus_1_hari,
                                contract_end_date_minus_14_hari,
                                contract_end_date_EN,
                                contract_end_date_plus_1_hari_EN,
                                contract_end_date_minus_14_hari_EN,
                                dataLengkap
                            )
                        );
                    }
                }

                system.debug('Set_toAddress_1 :'+ Set_toAddress_1);
                system.debug('Set_toCCAddress_1 :'+ Set_toCCAddress_1);
                system.debug('Set_toBCCAddress_1 :'+ Set_toBCCAddress_1);
                system.debug('Set_toAddress_2 :'+ Set_toAddress_2);
                system.debug('Set_toCCAddress_2 :'+ Set_toCCAddress_2);
                system.debug('Set_toBCCAddress_2 :'+ Set_toBCCAddress_2);

                system.debug('List_toAddress_1 All_contractExtension_90days_List :'+ List_toAddress_1);
                system.debug('List_toCCAddress_1 All_contractExtension_90days_List :'+ List_toCCAddress_1);
                system.debug('List_toBCCAddress_1 All_contractExtension_90days_List :'+ List_toBCCAddress_1);

                if(List_ContractExtension_UPD!=null && !List_ContractExtension_UPD.isEmpty()){
                    system.debug('List_ContractExtension_UPD : ' + List_ContractExtension_UPD.size()) ;
                    update List_ContractExtension_UPD;   
                }
            }

            if(All_contractExtension_SendBACustomer_Button_List!=null && !All_contractExtension_SendBACustomer_Button_List.isEmpty()){
                system.debug('All_contractExtension_SendBACustomer_Button_List_SIZE : '+ All_contractExtension_SendBACustomer_Button_List.size());

                List<Contract_Extension__c> List_ContractExtension_UPD = new List<Contract_Extension__c> ();

                contractExtension_List_AccountId = new Set<Id>();
                contractExtension_List_Email_Head_Sales = new Set<Id>();
                contractExtension_List_Email_GH_Sales = new Set<Id>();

                for(Contract_Extension__c All_contractExtension_SendBACustomer_Button_ListExtract : All_contractExtension_SendBACustomer_Button_List){
                    contractExtension_List_AccountId.add(All_contractExtension_SendBACustomer_Button_ListExtract.Account__c);
                    contractExtension_List_Email_Head_Sales.add(All_contractExtension_SendBACustomer_Button_ListExtract.Account_Manager__r.ManagerId);
                    contractExtension_List_Email_GH_Sales.add(All_contractExtension_SendBACustomer_Button_ListExtract.Account_Manager__r.ManagerId);
                }

                All_Contact_PICBARecipient = getContact_PICBARecipient(contractExtension_List_AccountId);
                All_Email_Head_Sales = getHead_Sales(contractExtension_List_Email_Head_Sales);
                All_Email_GH_Sales = getGH_Sales(contractExtension_List_Email_GH_Sales);

                /*system.debug('SIZE All_Contact_PICBARecipient :'+ All_Contact_PICBARecipient.size());
                system.debug('All_Contact_PICBARecipient :'+ All_Contact_PICBARecipient.size());*/

                Extract_Email_1_TerminationNonAutoRenewal_Setting('Email_1_SendBACustomer_Button_Setting');
                Extract_Email_3_TerminationNonAutoRenewal_Setting('Email_3_NoticeAdmin_Setting');

                Boolean dataLengkap = true;

                for(Contract_Extension__c All_contractExtension_SendBACustomer_Button_ListExtract : All_contractExtension_SendBACustomer_Button_List){
                    List_toAddress_1 = new List<string>();
                    List_toCCAddress_1 = new List<string>();
                    List_toBCCAddress_1 = new List<string>();
                    List_toAddress_3 = new List<string>();
                    List_toCCAddress_3 = new List<string>();
                    List_toBCCAddress_3 = new List<string>();

                    Set_toAddress_1 = new Set<string>();
                    Set_toCCAddress_1 = new Set<string>();
                    Set_toBCCAddress_1 = new Set<string>();
                    Set_toAddress_3 = new Set<string>();
                    Set_toCCAddress_3 = new Set<string>();
                    Set_toBCCAddress_3 = new Set<string>();

                    //------------- START SET EMAIL ADDRESS 1 -----------------------
                    if(All_contractExtension_SendBACustomer_Button_ListExtract.BA_Print__r.Email != null || All_contractExtension_SendBACustomer_Button_ListExtract.BA_Print__c != null){
                        String ContractExtensionid = All_contractExtension_SendBACustomer_Button_ListExtract.Id;

                        Set_toAddress_1.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        Set_toCCAddress_1.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        Set_toBCCAddress_1.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET);
                        
                        Set_toAddress_1.add(All_contractExtension_SendBACustomer_Button_ListExtract.BA_Print__r.Email);

                        if(All_Contact_PICBARecipient.get(All_contractExtension_SendBACustomer_Button_ListExtract.Account__c) != null){
                            Set_toAddress_1.add(All_Contact_PICBARecipient.get(All_contractExtension_SendBACustomer_Button_ListExtract.Account__c));
                        }
                        
                        if(All_contractExtension_SendBACustomer_Button_ListExtract.Account_Manager__r.Email != null){
                            Set_toCCAddress_1.add(All_contractExtension_SendBACustomer_Button_ListExtract.Account_Manager__r.Email);
                        }

                        if(All_Email_Head_Sales.get(All_contractExtension_SendBACustomer_Button_ListExtract.Account_Manager__r.ManagerId) != null){
                            Set_toCCAddress_1.add(All_Email_Head_Sales.get(All_contractExtension_SendBACustomer_Button_ListExtract.Account_Manager__r.ManagerId));
                        }

                        if(All_Email_GH_Sales.get(All_contractExtension_SendBACustomer_Button_ListExtract.Account_Manager__r.Manager_of_Manager__c) != null){
                            Set_toCCAddress_1.add(All_Email_GH_Sales.get(All_contractExtension_SendBACustomer_Button_ListExtract.Account_Manager__r.Manager_of_Manager__c));
                        }

                        Set_toAddress_1.remove('');
                        Set_toAddress_1.remove(null);
                        List_toAddress_1.addAll(Set_toAddress_1);

                        Set_toCCAddress_1.remove('');
                        Set_toCCAddress_1.remove(null);
                        List_toCCAddress_1.addAll(Set_toCCAddress_1);

                        Set_toBCCAddress_1.remove('');
                        Set_toBCCAddress_1.remove(null);
                        List_toBCCAddress_1.addAll(Set_toBCCAddress_1);
                        //------------- END SET EMAIL ADDRESS 1 -----------------------

                        String contract_name = All_contractExtension_SendBACustomer_Button_ListExtract.name;
                        String customer_name = All_contractExtension_SendBACustomer_Button_ListExtract.Account__r.Name;
                        Integer dateValueINT = Integer.valueOf(All_contractExtension_SendBACustomer_Button_ListExtract.Going_To_Days__c);
                        String dateValue = String.valueOf(dateValueINT);

                        String emailTemplateSet = 'sendEmail_1';
                        String dateValueIND = '';
                        String dateValueEN = '';

                        if(dateValueINT < 0){
                            emailTemplateSet = 'sendEmail_minusDate';
                            dateValueIND = '';
                            dateValueEN = '';
                        }else if(dateValueINT < 14){
                            emailTemplateSet = 'sendEmail_Less_14Days';
                            dateValueIND = AppUtils.terbilang(Integer.valueOf(All_contractExtension_SendBACustomer_Button_ListExtract.Going_To_Days__c));
                            dateValueEN = AppUtils.terbilang_Inggris(Integer.valueOf(All_contractExtension_SendBACustomer_Button_ListExtract.Going_To_Days__c));
                        }else{
                            emailTemplateSet = 'sendEmail_1';
                            dateValueIND = AppUtils.terbilang(Integer.valueOf(All_contractExtension_SendBACustomer_Button_ListExtract.Going_To_Days__c));
                            dateValueEN = AppUtils.terbilang_Inggris(Integer.valueOf(All_contractExtension_SendBACustomer_Button_ListExtract.Going_To_Days__c));
                        }
                        
                        String product_name = All_contractExtension_SendBACustomer_Button_ListExtract.Existing_Contract_item__r.Product__r.Name;
                        String LID = All_contractExtension_SendBACustomer_Button_ListExtract.Link__r.Link_ID__c;
                        String site_name = '';
                        if(String.isNotBlank(All_contractExtension_SendBACustomer_Button_ListExtract.Link__r.Site_A_Name__r.Name) && String.isNotBlank(All_contractExtension_SendBACustomer_Button_ListExtract.Link__r.Site_A_Name__r.Unique_Name__c)){
                            site_name = All_contractExtension_SendBACustomer_Button_ListExtract.Link__r.Site_A_Name__r.Name + ' ' + All_contractExtension_SendBACustomer_Button_ListExtract.Link__r.Site_A_Name__r.Unique_Name__c;
                        }else{
                            site_name = All_contractExtension_SendBACustomer_Button_ListExtract.Link__r.Site_A_Name__r.Name;
                        }

                        String site_name2 = '';
                        if(String.isNotBlank(All_contractExtension_SendBACustomer_Button_ListExtract.Link__r.Site_A_Name__r.Unique_Name__c)){
                            site_name2 = All_contractExtension_SendBACustomer_Button_ListExtract.Link__r.Site_A_Name__r.Unique_Name__c;
                        }

                        Date contract_end_date_value = All_contractExtension_SendBACustomer_Button_ListExtract.Existing_Contract_item__r.End_Date__c;
                        String contract_end_date_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_value);
                        String contract_end_date = contract_end_date_value.day() + ' ' + contract_end_date_month + ' ' + contract_end_date_value.year();
                        String contract_end_date_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_value);
                        String contract_end_date_EN = contract_end_date_value.day() + ' ' + contract_end_date_month_EN + ' ' + contract_end_date_value.year();

                        Date contract_end_date_plus_1_hari_value = All_contractExtension_SendBACustomer_Button_ListExtract.Existing_Contract_item__r.End_Date__c.addDays(1);
                        String contract_end_date_plus_1_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_plus_1_hari_value);
                        String contract_end_date_plus_1_hari = contract_end_date_plus_1_hari_value.day() + ' ' + contract_end_date_plus_1_hari_month + ' ' + contract_end_date_plus_1_hari_value.year();
                        String contract_end_date_plus_1_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_plus_1_hari_value);
                        String contract_end_date_plus_1_hari_EN = contract_end_date_plus_1_hari_value.day() + ' ' + contract_end_date_plus_1_hari_month_EN + ' ' + contract_end_date_plus_1_hari_value.year();

                        Date contract_end_date_minus_14_hari_value = All_contractExtension_SendBACustomer_Button_ListExtract.Existing_Contract_item__r.End_Date__c.addDays(-14);
                        String contract_end_date_minus_14_hari_month = AppUtils.getDateMonthName_FORMAT_MM_ID(contract_end_date_minus_14_hari_value);
                        String contract_end_date_minus_14_hari  = contract_end_date_minus_14_hari_value.day() + ' ' + contract_end_date_minus_14_hari_month + ' ' + contract_end_date_minus_14_hari_value.year();
                        String contract_end_date_minus_14_hari_month_EN = AppUtils.getDateMonthName_FORMAT_MM_EN(contract_end_date_minus_14_hari_value);
                        String contract_end_date_minus_14_hari_EN  = contract_end_date_minus_14_hari_value.day() + ' ' + contract_end_date_minus_14_hari_month_EN + ' ' + contract_end_date_minus_14_hari_value.year();

                        String AM_name = All_contractExtension_SendBACustomer_Button_ListExtract.Account_Manager__r.Name;
                        String Head_name = Name_User_HeadSales.get(All_contractExtension_SendBACustomer_Button_ListExtract.Account_Manager__r.ManagerId);
                        String GH_name = Name_User_GHSales.get(All_contractExtension_SendBACustomer_Button_ListExtract.Account_Manager__r.Manager_of_Manager__c);

                        Integer no_suratCount = 0 + 1;

                        If(All_contractExtension_SendBACustomer_Button_ListExtract.Email_Tenar_Count__c != null){
                            no_suratCount = Integer.ValueOf(All_contractExtension_SendBACustomer_Button_ListExtract.Email_Tenar_Count__c) + 1;
                        }

                        All_contractExtension_SendBACustomer_Button_ListExtract.Email_Tenar_Count__c = no_suratCount;
                        List_ContractExtension_UPD.add(All_contractExtension_SendBACustomer_Button_ListExtract);

                        String no_surat = String.ValueOf(no_suratCount);
                        String no_surat_suffix = appUtils.getNumberSuffix(Integer.ValueOf(no_surat));

                        if(emailTemplateSet == 'sendEmail_minusDate'){
                            sendEmailList.add(
                                sendEmail_minusDate(
                                    ContractExtensionid,
                                    List_toAddress_1,
                                    List_toCCAddress_1,
                                    List_toBCCAddress_1,
                                    no_surat,
                                    no_surat_suffix,
                                    contract_name,
                                    customer_name,
                                    dateValue,
                                    dateValueIND,
                                    dateValueEN,
                                    product_name,
                                    LID,
                                    site_name,
                                    site_name2,
                                    contract_end_date,
                                    contract_end_date_plus_1_hari,
                                    contract_end_date_minus_14_hari,
                                    contract_end_date_EN,
                                    contract_end_date_plus_1_hari_EN,
                                    contract_end_date_minus_14_hari_EN
                                )
                            );
                        }else if(emailTemplateSet == 'sendEmail_Less_14Days'){
                            sendEmailList.add(
                                sendEmail_Less_14Days(
                                    ContractExtensionid,
                                    List_toAddress_1,
                                    List_toCCAddress_1,
                                    List_toBCCAddress_1,
                                    no_surat,
                                    no_surat_suffix,
                                    contract_name,
                                    customer_name,
                                    dateValue,
                                    dateValueIND,
                                    dateValueEN,
                                    product_name,
                                    LID,
                                    site_name,
                                    site_name2,
                                    contract_end_date,
                                    contract_end_date_plus_1_hari,
                                    contract_end_date_minus_14_hari,
                                    contract_end_date_EN,
                                    contract_end_date_plus_1_hari_EN,
                                    contract_end_date_minus_14_hari_EN
                                )
                            );
                        }else if(emailTemplateSet == 'sendEmail_1'){
                            sendEmailList.add(
                                sendEmail_1(
                                    ContractExtensionid,
                                    List_toAddress_1,
                                    List_toCCAddress_1,
                                    List_toBCCAddress_1,
                                    no_surat,
                                    no_surat_suffix,
                                    contract_name,
                                    customer_name,
                                    dateValue,
                                    dateValueIND,
                                    dateValueEN,
                                    product_name,
                                    LID,
                                    site_name,
                                    site_name2,
                                    contract_end_date,
                                    contract_end_date_plus_1_hari,
                                    contract_end_date_minus_14_hari,
                                    contract_end_date_EN,
                                    contract_end_date_plus_1_hari_EN,
                                    contract_end_date_minus_14_hari_EN,
                                    dataLengkap
                                )
                            );
                        }
                    }else{
                        Set_toAddress_3.addAll(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);
                        Set_toCCAddress_3.addAll(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);
                        Set_toBCCAddress_3.addAll(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET);

                        List_toAddress_3.addAll(Set_toAddress_3);
                        List_toCCAddress_3.addAll(Set_toCCAddress_3);
                        List_toBCCAddress_3.addAll(Set_toBCCAddress_3);

                        String contract_name = All_contractExtension_SendBACustomer_Button_ListExtract.name;
                        String contractId = All_contractExtension_SendBACustomer_Button_ListExtract.id;
                        String PIC_BA_Print = All_contractExtension_SendBACustomer_Button_ListExtract.BA_Print__r.Name;
                        String Email = All_contractExtension_SendBACustomer_Button_ListExtract.BA_Print__r.email;

                        sendEmailList.add(
                            sendEmail_3(
                                List_toAddress_3, 
                                List_toCCAddress_3,
                                List_toBCCAddress_3,
                                contract_name,
                                contractId,
                                PIC_BA_Print,
                                Email
                            )
                        );
                    }
                }

                /*system.debug('Set_toAddress_1 :'+ Set_toAddress_1);
                system.debug('Set_toCCAddress_1 :'+ Set_toCCAddress_1);
                system.debug('Set_toAddress_2 :'+ Set_toAddress_2);
                system.debug('Set_toCCAddress_2 :'+ Set_toCCAddress_2);*/

                system.debug('List_toAddress_1 All_contractExtension_SendBACustomer_Button_List_List :'+ List_toAddress_1);
                system.debug('List_toCCAddress_1 All_contractExtension_SendBACustomer_Button_List_List :'+ List_toCCAddress_1);
                system.debug('List_toBCCAddress_1 All_contractExtension_SendBACustomer_Button_List_List :'+ List_toBCCAddress_1);

                if(List_ContractExtension_UPD!=null && !List_ContractExtension_UPD.isEmpty()){
                    system.debug('List_ContractExtension_UPD : ' + List_ContractExtension_UPD.size()) ;
                    update List_ContractExtension_UPD;   
                }
            }

            system.debug('sendEmailListSize : ' + sendEmailList.size()) ;
            if(sendEmailList!=null && !sendEmailList.isEmpty())
            {
                Messaging.sendEmail(sendEmailList,true);    
            }

        }catch (Exception e) {
            String err_message = 'Error on Email_Notif_TerminationNonAutoRenewal.cls - Email_Notif_TerminationNonAutoRenewal ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }

    }

    public Messaging.SingleEmailMessage sendEmail_1(
        String ContractExtensionid,
        List<string> List_toAddress_1, 
        List<string> List_toCCAddress_1,
        List<string> List_toBCCAddress_1,
        String no_surat,
        String no_surat_suffix,
        String contract_name,
        String customer_name,
        String dateValue,
        String dateValueIND,
        String dateValueEN,
        String product_name,
        String LID,
        String site_name,
        String site_name2,
        String contract_end_date,
        String contract_end_date_plus_1_hari,
        String contract_end_date_minus_14_hari,
        String contract_end_date_EN,
        String contract_end_date_plus_1_hari_EN,
        String contract_end_date_minus_14_hari_EN,
        Boolean dataLengkap
    ){
        Blob body = Blob.valueOf('sendEmail_1');
        if(!Test.isRunningTest()){
            PageReference pdf = page.ContractExtensionBA;
            pdf.getParameters().put('id',ContractExtensionid);

            body = pdf.getContent();
        }

        String AttachmentNameFormat = site_name + ' ' + LID;
        String AttachmentName = AttachmentNameFormat.replaceAll('\\s+','_');

        String SubjectEmailFormat_1 = '[' + no_surat + no_surat_suffix + ' reminder for H-' + dateValue + '] Berita Acara Perpanjangan ' + contract_name + ' ' + site_name;

        String SubjectEmailFormat_1_1 = '[reminder for H-' + dateValue + '] Berita Acara Perpanjangan ' + contract_name + ' ' + site_name;

        String bodyEmailFormat_1 = 
        'Pelanggan Yang Terhormat ' + customer_name + ',' +
        '<br><br>' +
        'Bersama ini kami sampaikan bahwa dalam ' + dateValue + ' ('+dateValueIND+') hari ke depan kontrak layanan ' + product_name + ' ' + LID + ' - ' + customer_name + ' ' + site_name2 + ' akan berakhir, yaitu pada tanggal ' + contract_end_date + ', dengan pemutusan layanan pada ' + contract_end_date_plus_1_hari + '.' +
        '<br><br>' +
        'Apabila penggunaan layanan tersebut akan dilanjutkan, terlampir Berita Acara Perpanjangan untuk ditanda-tangani oleh ' + customer_name + ' dan selambat-lambatnya kami terima melalui email pada tanggal ' + contract_end_date_minus_14_hari + '.' +
        '<br><br>' +
        'Untuk informasi lebih lanjut mengenai kontrak layanan ini, ' + customer_name + ' dapat menghubungi XL Account Manager dan Sales Manager terkait.' +
        '<br><br><br>' +
        'Hormat kami,' +
        '<br>' +
        'XL Business Solutions' +
        '<br><br><br><br>' +
        '---------------------------------------------------------------------------------------------------------------------------------------------------------' +
        '<br><br><br><br>' +
        'Dear Valued Customer ' + customer_name + ',' +
        '<br><br>' +
        'We hereby inform you that in the next ' + dateValue + ' ('+dateValueEN+') days the contract of ' + product_name + ' ' + LID + ' - ' + customer_name + ' ' + site_name2 + ' will end, that is on ' + contract_end_date_EN + ' with service termination on ' + contract_end_date_plus_1_hari_EN + '.' +
        '<br><br>' +
        'Should the service be continued, ' + customer_name + ' needs to sign Letter of Extension as attached, and we expect to receive it via email on ' + contract_end_date_minus_14_hari_EN + ' at the latest.' +
        '<br><br>' +
        'For any information about the contract detail, kindly contact respective XL Account Manager and Sales Manager.'+
        '<br><br><br>' +
        'Best regards,'+
        '<br>' +
        'XL Business Solutions'
        ;

        Messaging.SingleEmailMessage mail_1 = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='operationrevenuemanagement@xl.co.id'];
        mail_1.setOrgWideEmailAddressId(owea.get(0).Id);
        mail_1.optOutPolicy = 'FILTER';

        if(dataLengkap == true){
            mail_1.setSubject(SubjectEmailFormat_1);
        }else{
            mail_1.setSubject(SubjectEmailFormat_1_1);
        }

        mail_1.setHtmlBody(bodyEmailFormat_1);
        if(List_toAddress_1!=null && !List_toAddress_1.isEmpty()) {
            mail_1.setToAddresses(List_toAddress_1);
        }
        if(List_toCCAddress_1!=null && !List_toCCAddress_1.isEmpty()) {
            mail_1.setCcAddresses(List_toCCAddress_1);
        }
        if(List_toBCCAddress_1!=null && !List_toBCCAddress_1.isEmpty()) {
            mail_1.setBccAddresses(List_toBCCAddress_1);
        }

        //mail_1.setToAddresses(new String[]{'Novando.Agmawan@saasten.com'});

        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName(AttachmentName+'.pdf');
        attach.setInline(false);
        attach.Body = body;

        mail_1.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });

        return mail_1;
    }

    public Messaging.SingleEmailMessage sendEmail_1_ForH1(
        String ContractExtensionid,
        List<string> List_toAddress_1, 
        List<string> List_toCCAddress_1,
        List<string> List_toBCCAddress_1,
        String no_surat,
        String no_surat_suffix,
        String contract_name,
        String customer_name,
        String dateValue,
        String dateValueIND,
        String dateValueEN,
        String product_name,
        String LID,
        String site_name,
        String site_name2,
        String contract_end_date,
        String contract_end_date_plus_1_hari,
        String contract_end_date_minus_14_hari,
        String contract_end_date_EN,
        String contract_end_date_plus_1_hari_EN,
        String contract_end_date_minus_14_hari_EN,
        Boolean dataLengkap
    ){
        Blob body = Blob.valueOf('sendEmail_1');
        if(!Test.isRunningTest()){
            PageReference pdf = page.ContractExtensionBA;
            pdf.getParameters().put('id',ContractExtensionid);

            body = pdf.getContent();
        }

        String SubjectEmailFormat_1 = '';
        String bodyEmailFormat_1 = '';

        String AttachmentNameFormat = site_name + ' ' + LID;
        String AttachmentName = AttachmentNameFormat.replaceAll('\\s+','_');

        String SubjectEmailFormat_1_1 = '[reminder for H-' + dateValue + '] Service Termination Due No ' + contract_name + ' ' + site_name;

        if(!test.isrunningtest()){
            SubjectEmailFormat_1 = emailTemplate.subject;
            SubjectEmailFormat_1 = SubjectEmailFormat_1.replace('{!!dateValue}', dateValue);
            SubjectEmailFormat_1 = SubjectEmailFormat_1.replace('{!!noSurat}', no_surat);
            SubjectEmailFormat_1 = SubjectEmailFormat_1.replace('{!!noSuratSuffix}', no_surat_suffix);
            SubjectEmailFormat_1 = SubjectEmailFormat_1.replace('{!!contractName}', contract_name);
            SubjectEmailFormat_1 = SubjectEmailFormat_1.replace('{!!SiteName}', site_name);
        

            bodyEmailFormat_1 = emailTemplate.HtmlValue;
            bodyEmailFormat_1 = bodyEmailFormat_1.replace('{!!customerName}', customer_name);
            bodyEmailFormat_1 = bodyEmailFormat_1.replace('{!!dateValue}', dateValue);
            bodyEmailFormat_1 = bodyEmailFormat_1.replace('{!!dateValueIND}', dateValueIND);
            bodyEmailFormat_1 = bodyEmailFormat_1.replace('{!!productName}', product_name);
            bodyEmailFormat_1 = bodyEmailFormat_1.replace('{!!LID}', LID);
            bodyEmailFormat_1 = bodyEmailFormat_1.replace('{!!siteName2}', site_name2);
            bodyEmailFormat_1 = bodyEmailFormat_1.replace('{!!dateValueEN}', dateValueEN);
        }

        system.debug('sendEmail_1_ForH1 SubjectEmailFormat_1 : ' + SubjectEmailFormat_1);

        system.debug('sendEmail_1_ForH1 bodyEmailFormat_1 : ' + bodyEmailFormat_1) ;

        Messaging.SingleEmailMessage mail_1 = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='operationrevenuemanagement@xl.co.id'];
        mail_1.setOrgWideEmailAddressId(owea.get(0).Id);
        mail_1.optOutPolicy = 'FILTER';

        if(dataLengkap == true){
            mail_1.setSubject(SubjectEmailFormat_1);
        }else{
            mail_1.setSubject(SubjectEmailFormat_1_1);
        }

        mail_1.setHtmlBody(bodyEmailFormat_1);

        if(List_toAddress_1!=null && !List_toAddress_1.isEmpty()) {
            mail_1.setToAddresses(List_toAddress_1);
        }
        if(List_toCCAddress_1!=null && !List_toCCAddress_1.isEmpty()) {
            mail_1.setCcAddresses(List_toCCAddress_1);
        }
        if(List_toBCCAddress_1!=null && !List_toBCCAddress_1.isEmpty()) {
            mail_1.setBccAddresses(List_toBCCAddress_1);
        }

        //mail_1.setToAddresses(new String[]{'Novando.Agmawan@saasten.com'});

        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName(AttachmentName+'.pdf');
        attach.setInline(false);
        attach.Body = body;

        //mail_1.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });

        return mail_1;
    }

    public Messaging.SingleEmailMessage sendEmail_2(
        List<string> List_toAddress_2, 
        List<string> List_toCCAddress_2,
        List<string> List_toBCCAddress_2,
        String no_surat,
        String no_surat_suffix,
        String contract_name,
        String AM_name,
        String Head_name,
        String GH_name,
        String dateValue,
        String dateValueIND,
        String product_name,
        String LID,
        String customer_name,
        String site_name,
        String site_name2,
        String contract_end_date,
        String contract_end_date_minus_14_hari,
        String contract_end_date_plus_1_hari,
        String contract_end_date_minus_30_hari,
        String Recordlink,
        String BAP_no
    ){
        //String SubjectEmailFormat_2 = '[' + no_surat + no_surat_suffix + ' reminder for H-' + dateValue + '] Berita Acara Perpanjangan ' + contract_name + ' ' + site_name;
        String SubjectEmailFormat_2 = '[' + no_surat + no_surat_suffix + 'H-' + dateValue + '] Service Termination Due No ' + contract_name + ' ' + site_name;
        String bodyEmailFormat_2 =
        'Dear ' + AM_name + ', ' + Head_name + ', ' + GH_name + ',' +
        '<br><br>' +
        'Dalam ' + dateValue + ' ('+dateValueIND+') hari ke depan kontrak layanan ' + product_name + ' ' + LID + ' - ' + customer_name + ' ' + site_name2 + ' akan berakhir, yaitu pada tanggal ' + contract_end_date + '.' +
        '<br><br>' +
        'Apabila Berita Acara Perpanjangan yang telah ditanda-tangani oleh ' + customer_name + ' belum diterima oleh XL sampai dengan tanggal ' + contract_end_date_minus_14_hari + ' , maka pemutusan layanan akan dilakukan pada tanggal ' + contract_end_date_plus_1_hari + '.' +
        '<br><br>' +
        /*'Per tanggal ' + contract_end_date_minus_30_hari + ' Berita Acara Perpanjangan yang belum diterima oleh XL dicatat sebagai Pending Recurring dan otomatis dibuatkan Berita Acara Pemutusan.' +
        '<br><br>' +*/
        'Apabila pelanggan setuju untuk memperpanjang layanan, silahkan  klik link Berita Acara Pemutusan berikut untuk memproses pembatalan Berita Acara Pemutusan.' +
        '<br>' +
        '<a href="'+Recordlink+'" target="_blank">'+BAP_no+'</a></td>' +
        '<br><br>' +
        'Untuk informasi lebih lanjut mengenai Berita Acara Perpanjangan layanan, dapat berkoordinasi dengan tim Operation Revenue Management.' + 
        '<br><br><br>' +
        'Regards,' +
        '<br>' +
        'XL Busol - Operations'
        ;

        Messaging.SingleEmailMessage mail_2 = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='operationrevenuemanagement@xl.co.id'];
        mail_2.setOrgWideEmailAddressId(owea.get(0).Id);
        mail_2.optOutPolicy = 'FILTER';
        mail_2.setSubject(SubjectEmailFormat_2);
        mail_2.setHtmlBody(bodyEmailFormat_2);
        if(List_toAddress_2!=null && !List_toAddress_2.isEmpty()) {
            mail_2.setToAddresses(List_toAddress_2);
        }

        if(List_toCCAddress_2!=null && !List_toCCAddress_2.isEmpty()) {
            mail_2.setCcAddresses(List_toCCAddress_2);
        }

        if(List_toBCCAddress_2!=null && !List_toBCCAddress_2.isEmpty()) {
            mail_2.setBccAddresses(List_toBCCAddress_2);
        }

        //mail_2.setToAddresses(new String[]{'Novando.Agmawan@saasten.com'});

        return mail_2;
    }

    //--> Email Handling Jika PICBAPrint Kosong
    public Messaging.SingleEmailMessage sendEmail_3(
        List<string> List_toAddress_3, 
        List<string> List_toCCAddress_3,
        List<string> List_toBCCAddress_3,
        String contract_name,
        String contractId,
        String PIC_BA_Print,
        String Email
    ){
        String Link_Record = URL.getSalesforceBaseUrl().toExternalForm()+'/'+contractId;

        String SubjectEmailFormat_3 = 'WARNING : Berita Acara Perpanjangan ' + contract_name + ' Tidak ada PIC BA Print atau email' ;
        String bodyEmailFormat_3 =
        'Detail Information : '+
        '<br><br>' +
        'Contract Name : ' + contract_name + 
        '<br>' +
        'Link Record : ' + Link_Record + 
        '<br>' +
        'PIC BA Print : ' + PIC_BA_Print + 
        '<br>' +
        'Email : ' + Email + 
        '<br><br><br>' +
        'Regards,' +
        '<br>' +
        'System Administrator'
        ;

        Messaging.SingleEmailMessage mail_3 = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='operationrevenuemanagement@xl.co.id'];
        mail_3.setOrgWideEmailAddressId(owea.get(0).Id);
        mail_3.optOutPolicy = 'FILTER';
        mail_3.setSubject(SubjectEmailFormat_3);
        mail_3.setHtmlBody(bodyEmailFormat_3);
        if(List_toAddress_3!=null && !List_toAddress_3.isEmpty()) {
            mail_3.setToAddresses(List_toAddress_3);
        }
        
        if(List_toCCAddress_3!=null && !List_toCCAddress_3.isEmpty()) {
            mail_3.setCcAddresses(List_toCCAddress_3);
        }

        if(List_toBCCAddress_3!=null && !List_toBCCAddress_3.isEmpty()) {
            mail_3.setBccAddresses(List_toBCCAddress_3);
        }

        //mail_3.setToAddresses(new String[]{'Novando.Agmawan@saasten.com'});

        return mail_3;
    }

    public Messaging.SingleEmailMessage sendEmail_minusDate(
        String ContractExtensionid,
        List<string> List_toAddress_1, 
        List<string> List_toCCAddress_1,
        List<string> List_toBCCAddress_1,
        String no_surat,
        String no_surat_suffix,
        String contract_name,
        String customer_name,
        String dateValue,
        String dateValueIND,
        String dateValueEN,
        String product_name,
        String LID,
        String site_name,
        String site_name2,
        String contract_end_date,
        String contract_end_date_plus_1_hari,
        String contract_end_date_minus_14_hari,
        String contract_end_date_EN,
        String contract_end_date_plus_1_hari_EN,
        String contract_end_date_minus_14_hari_EN
    ){
        Blob body = Blob.valueOf('sendEmail_minusDate');
        if(!Test.isRunningTest()){
            PageReference pdf = page.ContractExtensionBA;
            pdf.getParameters().put('id',ContractExtensionid);

            body = pdf.getContent();
        }

        String AttachmentNameFormat = site_name + ' ' + LID;
        String AttachmentName = AttachmentNameFormat.replaceAll('\\s+','_');

        String SubjectEmailFormat_1 = '[' + no_surat + no_surat_suffix + ' reminder for H-' + dateValue + '] Berita Acara Perpanjangan ' + contract_name + ' ' + site_name;
        String bodyEmailFormat_1 = 
        'Pelanggan Yang Terhormat ' + customer_name + ',' +
        '<br><br>' +
        'Bersama ini kami sampaikan bahwa kontrak layanan ' + product_name + ' ' + LID + ' - ' + customer_name + ' ' + site_name2 + ' telah berakhir.' +
        '<br><br>' +
        'Apabila penggunaan layanan tersebut akan dilanjutkan, terlampir Berita Acara Perpanjangan untuk ditanda-tangani oleh ' + customer_name + ' agar dapat segera di proses kontrak perpanjangan dari layanan tersebut.' + 
        '<br><br>' +
        'Untuk informasi lebih lanjut mengenai kontrak layanan ini, ' + customer_name + ' dapat menghubungi XL Account Manager dan Sales Manager terkait.' +
        '<br><br><br>' +
        'Hormat kami,' +
        '<br>' +
        'XL Business Solutions' +
        '<br><br><br><br>' +
        '---------------------------------------------------------------------------------------------------------------------------------------------------------' +
        '<br><br><br><br>' +
        'Dear Valued Customer ' + customer_name + ',' +
        '<br><br>' +
        'We hereby announce that the service contract ' + product_name + ' ' + LID + ' - ' + customer_name + ' ' + site_name2 + ' have ended.' +
        '<br><br>' +
        'Should the service be continued, ' + customer_name + ' needs to sign Letter of Extension as attached, so that the contract extension of the service can be processed immediately.' +
        '<br><br>' +
        'For any information about the contract detail, kindly contact respective XL Account Manager and Sales Manager.'+
        '<br><br><br>' +
        'Best regards,'+
        '<br>' +
        'XL Business Solutions'
        ;

        Messaging.SingleEmailMessage mail_1 = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='operationrevenuemanagement@xl.co.id'];
        mail_1.setOrgWideEmailAddressId(owea.get(0).Id);
        mail_1.optOutPolicy = 'FILTER';
        mail_1.setSubject(SubjectEmailFormat_1);
        mail_1.setHtmlBody(bodyEmailFormat_1);
        if(List_toAddress_1!=null && !List_toAddress_1.isEmpty()) {
            mail_1.setToAddresses(List_toAddress_1);
        }
        if(List_toCCAddress_1!=null && !List_toCCAddress_1.isEmpty()) {
            mail_1.setCcAddresses(List_toCCAddress_1);
        }
        if(List_toBCCAddress_1!=null && !List_toBCCAddress_1.isEmpty()) {
            mail_1.setBccAddresses(List_toBCCAddress_1);
        }

        //mail_1.setToAddresses(new String[]{'Novando.Agmawan@saasten.com'});

        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName(AttachmentName+'.pdf');
        attach.setInline(false);
        attach.Body = body;

        mail_1.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });

        return mail_1;
    }

    public Messaging.SingleEmailMessage sendEmail_Less_14Days(
        String ContractExtensionid,
        List<string> List_toAddress_1, 
        List<string> List_toCCAddress_1,
        List<string> List_toBCCAddress_1,
        String no_surat,
        String no_surat_suffix,
        String contract_name,
        String customer_name,
        String dateValue,
        String dateValueIND,
        String dateValueEN,
        String product_name,
        String LID,
        String site_name,
        String site_name2,
        String contract_end_date,
        String contract_end_date_plus_1_hari,
        String contract_end_date_minus_14_hari,
        String contract_end_date_EN,
        String contract_end_date_plus_1_hari_EN,
        String contract_end_date_minus_14_hari_EN
    ){
        Blob body = Blob.valueOf('sendEmail_Less_14Days');
        if(!Test.isRunningTest()){
            PageReference pdf = page.ContractExtensionBA;
            pdf.getParameters().put('id',ContractExtensionid);

            body = pdf.getContent();
        }

        String AttachmentNameFormat = site_name + ' ' + LID;
        String AttachmentName = AttachmentNameFormat.replaceAll('\\s+','_');

        String SubjectEmailFormat_1 = '[' + no_surat + no_surat_suffix + ' reminder for H-' + dateValue + '] Berita Acara Perpanjangan ' + contract_name + ' ' + site_name;
        String bodyEmailFormat_1 = 
        'Pelanggan Yang Terhormat ' + customer_name + ',' +
        '<br><br>' +
        'Bersama ini kami sampaikan bahwa dalam ' + dateValue + ' ('+dateValueIND+') hari ke depan kontrak layanan ' + product_name + ' ' + LID + ' - ' + customer_name + ' ' + site_name2 + ' akan berakhir, yaitu pada tanggal ' + contract_end_date + ', dengan pemutusan layanan pada ' + contract_end_date_plus_1_hari + '.' +
        '<br><br>' +
        'Apabila penggunaan layanan tersebut akan dilanjutkan, terlampir Berita Acara Perpanjangan untuk ditanda-tangani oleh ' + customer_name + ' dan dikirimkan segera sebelum kontrak berakhir. ' +
        '<br><br>' +
        'Untuk informasi lebih lanjut mengenai kontrak layanan ini, ' + customer_name + ' dapat menghubungi XL Account Manager dan Sales Manager terkait.' +
        '<br><br><br>' +
        'Hormat kami,' +
        '<br>' +
        'XL Business Solutions' +
        '<br><br><br><br>' +
        '---------------------------------------------------------------------------------------------------------------------------------------------------------' +
        '<br><br><br><br>' +
        'Dear Valued Customer ' + customer_name + ',' +
        '<br><br>' +
        'We hereby inform you that in the next ' + dateValue + ' ('+dateValueEN+') days the contract of ' + product_name + ' ' + LID + ' - ' + customer_name + ' ' + site_name2 + ' will end, that is on ' + contract_end_date_EN + ' with service termination on ' + contract_end_date_plus_1_hari_EN + '.' +
        '<br><br>' +
        'Should the service be continued, ' + customer_name + ' needs to sign Letter of Extension as attached, and delivered immediately before the contract ends. ' +
        '<br><br>' +
        'For any information about the contract detail, kindly contact respective XL Account Manager and Sales Manager.'+
        '<br><br><br>' +
        'Best regards,'+
        '<br>' +
        'XL Business Solutions'
        ;

        Messaging.SingleEmailMessage mail_1 = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='operationrevenuemanagement@xl.co.id'];
        mail_1.setOrgWideEmailAddressId(owea.get(0).Id);
        mail_1.optOutPolicy = 'FILTER';
        mail_1.setSubject(SubjectEmailFormat_1);
        mail_1.setHtmlBody(bodyEmailFormat_1);
        if(List_toAddress_1!=null && !List_toAddress_1.isEmpty()) {
            mail_1.setToAddresses(List_toAddress_1);
        }
        if(List_toCCAddress_1!=null && !List_toCCAddress_1.isEmpty()) {
            mail_1.setCcAddresses(List_toCCAddress_1);
        }
        if(List_toBCCAddress_1!=null && !List_toBCCAddress_1.isEmpty()) {
            mail_1.setBccAddresses(List_toBCCAddress_1);
        }

        //mail_1.setToAddresses(new String[]{'Novando.Agmawan@saasten.com'});

        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName(AttachmentName+'.pdf');
        attach.setInline(false);
        attach.Body = body;

        mail_1.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });

        return mail_1;
    }

    public Map<Id, string> getContact_PICBARecipient(Set<Id> accIds){
        Map<Id, string> Email_contact_PICBARecipient = new Map<Id, String>();
        List<AccountContactRelation> contact_PICBARecipient = [SELECT ContactId, Contact_Email__c, AccountId FROM AccountContactRelation WHERE Roles INCLUDES ('PIC BA Recipient') AND AccountId IN:accIds];

        //system.debug('contact_PICBARecipient_size :'+ contact_PICBARecipient.size());
        //system.debug('contact_PICBARecipient :'+ contact_PICBARecipient);

        if(contact_PICBARecipient!=null && !contact_PICBARecipient.isEmpty()){
            for(AccountContactRelation contact_PICBARecipient_Extract : contact_PICBARecipient){
                Email_contact_PICBARecipient.put(contact_PICBARecipient_Extract.AccountId, contact_PICBARecipient_Extract.Contact_Email__c);
            }
            //system.debug('SIZE Email_contact_PICBARecipient :'+ Email_contact_PICBARecipient.size());
            //system.debug('Email_contact_PICBARecipient :'+ Email_contact_PICBARecipient);
        }

        return Email_contact_PICBARecipient;
    }

    //--> Sales Manager
    public Map<Id, string> getHead_Sales(Set<Id> userIds){
        Map<Id, string> Email_User_HeadSales = new Map<Id, String>();
        Name_User_HeadSales = new Map<Id, String>();
        
        List<User> user_HeadSales_List = [SELECT Name, Id, Email FROM USER WHERE Id IN:userIds];

        //system.debug('user_HeadSales_List_size :'+ user_HeadSales_List.size());
        //system.debug('user_HeadSales_List :'+ user_HeadSales_List);

        if(user_HeadSales_List!=null && !user_HeadSales_List.isEmpty()){
            For(User user_HeadSales_List_Extract : user_HeadSales_List){
                Email_User_HeadSales.put(user_HeadSales_List_Extract.Id, user_HeadSales_List_Extract.Email);     
                Name_User_HeadSales.put(user_HeadSales_List_Extract.Id, user_HeadSales_List_Extract.Name);        
            }

            //system.debug('SIZE Email_User_HeadSales :'+ Email_User_HeadSales.size());
            //system.debug('Email_User_HeadSales :'+ Email_User_HeadSales);
        }

        return Email_User_HeadSales;
    }

    //--> Manager of Sales Manager
    public Map<Id, string> getGH_Sales(Set<Id> userIds){
        Map<Id, string> Email_User_GHSales = new Map<Id, String>();
        Name_User_GHSales = new Map<Id, String>();


        List<User> user_HeadSales_List = [SELECT Id, ManagerId FROM USER WHERE Id IN:userIds];

        //system.debug('user_HeadSales_List_size :'+ user_HeadSales_List.size());
        //system.debug('user_HeadSales_List :'+ user_HeadSales_List);

        if(user_HeadSales_List!=null && !user_HeadSales_List.isEmpty()){
            Set<Id> ManagerId_user_HeadSales = new set<Id>();

            For(User user_HeadSales_List_Extract : user_HeadSales_List){
                ManagerId_user_HeadSales.add(user_HeadSales_List_Extract.ManagerId);            
            }

            if(ManagerId_user_HeadSales!=null && !ManagerId_user_HeadSales.isEmpty()){
                List<User> user_GHSales_List = [SELECT Name, Id, Email FROM USER WHERE Id IN:ManagerId_user_HeadSales];

                for(User user_GHSales_List_Extract : user_GHSales_List){
                    String formatId = String.valueOf(user_GHSales_List_Extract.Id).substring(0, 15);
                    Id formatIdFix = formatId;
                    Email_User_GHSales.put(formatIdFix, user_GHSales_List_Extract.Email); 
                    Name_User_GHSales.put(formatIdFix, user_GHSales_List_Extract.Name);     
                }
            }

            //system.debug('SIZE Email_User_GHSales :'+ Email_User_GHSales.size());
            //system.debug('Email_User_GHSales :'+ Email_User_GHSales);
        }

        return Email_User_GHSales;
    }

    //--> Custom Setting
    public void getEmailTerminationNonAutoRenewal_Setting(){
        toAddress_EmailTerminationNonAutoRenewal_Setting_Map = new Map<string, String>();
        toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map = new Map<string, String>();
        toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map = new Map<string, String>();

        List<Email_TerminationNonAutoRenewal_Setting__c> EmailTerminationNonAutoRenewal_Setting_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c, Additional_toBCCAddress__c FROM Email_TerminationNonAutoRenewal_Setting__c];

        if(EmailTerminationNonAutoRenewal_Setting_List!=null && !EmailTerminationNonAutoRenewal_Setting_List.isEmpty()){
            for(Email_TerminationNonAutoRenewal_Setting__c EmailTerminationNonAutoRenewal_Setting_List_Extract : EmailTerminationNonAutoRenewal_Setting_List){
                if(EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toAddress__c != null || EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toAddress__c != ''){
                    toAddress_EmailTerminationNonAutoRenewal_Setting_Map.put(EmailTerminationNonAutoRenewal_Setting_List_Extract.Name, EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toAddress__c);
                }
                if(EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toCCAddress__c != null || EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toCCAddress__c != ''){
                    toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.put(EmailTerminationNonAutoRenewal_Setting_List_Extract.Name, EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toCCAddress__c);
                }
                if(EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toBCCAddress__c != null || EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toBCCAddress__c != ''){
                    toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.put(EmailTerminationNonAutoRenewal_Setting_List_Extract.Name, EmailTerminationNonAutoRenewal_Setting_List_Extract.Additional_toBCCAddress__c);
                }
            }
        }

        //System.debug('toAddress_EmailTerminationNonAutoRenewal_Setting_Map : ' + toAddress_EmailTerminationNonAutoRenewal_Setting_Map);
        //System.debug('toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map : ' + toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map);
    }

    Public Void Extract_Email_1_TerminationNonAutoRenewal_Setting(String settingName){
        Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = new List<String>();
        Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = new List<String>();
        Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = new List<String>();

        Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET = new Set<String>();
        Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET = new Set<String>();
        Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET = new Set<String>();

        if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName) != null){
            
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ')){ //space
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toAddress.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',')){ //koma
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\,',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toAddress.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|')){ //pipe
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\|',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toAddress.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //space dan koma
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toAddressFormat_1 = toAddress.replaceAll('\\,',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toAddressFormat_1.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //space dan pipe
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toAddressFormat_1 = toAddress.replaceAll('\\|',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toAddressFormat_1.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') && toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //koma dan pipe
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('[\\|\\,]',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toAddress.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //koma dan pipe dan space
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toAddressFormat_1 = toAddress.replaceAll('[\\|\\,]',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toAddressFormat_1.split(';');
            }
            if(!toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && !toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && !toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).split(';');
            }

        }

        if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName) != null){

            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ')){ //space
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toCCAddress.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',')){ //koma
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\,',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toCCAddress.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|')){ //pipe
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\|',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toCCAddress.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //space dan koma
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toCCAddressFormat_1 = toCCAddress.replaceAll('\\,',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toCCAddressFormat_1.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //space dan pipe
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toCCAddressFormat_1 = toCCAddress.replaceAll('\\|',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toCCAddressFormat_1.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') && toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //koma dan pipe
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('[\\|\\,]',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toCCAddress.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //koma dan pipe dan space
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toCCAddressFormat_1 = toCCAddress.replaceAll('[\\|\\,]',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toCCAddressFormat_1.split(';');
            }
            if(!toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && !toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && !toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',')){
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).split(';');
            }

        }

        if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName) != null){

            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ')){ //space
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toBCCAddress.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',')){ //koma
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\,',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toBCCAddress.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|')){ //pipe
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\|',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toBCCAddress.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //space dan koma
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toBCCAddressFormat_1 = toBCCAddress.replaceAll('\\,',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toBCCAddressFormat_1.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //space dan pipe
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toBCCAddressFormat_1 = toBCCAddress.replaceAll('\\|',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toBCCAddressFormat_1.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') && toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //koma dan pipe
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('[\\|\\,]',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toBCCAddress.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //koma dan pipe dan space
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toBCCAddressFormat_1 = toBCCAddress.replaceAll('[\\|\\,]',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toBCCAddressFormat_1.split(';');
            }
            if(!toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && !toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && !toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',')){
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).split(';');
            }

        }

        if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_List!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_List.isEmpty()) {
            for(String Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result : Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_List){
                if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result != null || Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result != ''){
                    Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.add(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result);
                }
            }
        }

        if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List.isEmpty()) {
            for(String Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result : Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List){
                if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result != null || Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result != ''){
                    Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.add(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result);
                }
            }
        }

        if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List.isEmpty()) {
            for(String Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result : Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_List){
                if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result != null || Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result != ''){
                    Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_SET.add(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result);
                }
            }
        }
    }

    Public Void Extract_Email_2_TerminationNonAutoRenewal_Setting(String settingName){
        Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = new List<String>();
        Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = new List<String>();
        Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = new List<String>();

        Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET = new Set<String>();
        Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET = new Set<String>();
        Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET = new Set<String>();

        if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName) != null){

            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ')){ //space
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toAddress.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',')){ //koma
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\,',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toAddress.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|')){ //pipe
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\|',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toAddress.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //space dan koma
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toAddressFormat_1 = toAddress.replaceAll('\\,',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toAddressFormat_1.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //space dan pipe
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toAddressFormat_1 = toAddress.replaceAll('\\|',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toAddressFormat_1.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') && toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //koma dan pipe
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('[\\|\\,]',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toAddress.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //koma dan pipe dan space
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toAddressFormat_1 = toAddress.replaceAll('[\\|\\,]',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toAddressFormat_1.split(';');
            }
            if(!toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && !toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && !toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).split(';');
            }

        }

        if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName) != null){

            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ')){ //space
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toCCAddress.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',')){ //koma
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\,',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toCCAddress.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|')){ //pipe
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\|',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toCCAddress.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //space dan koma
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toCCAddressFormat_1 = toCCAddress.replaceAll('\\,',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toCCAddressFormat_1.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //space dan pipe
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toCCAddressFormat_1 = toCCAddress.replaceAll('\\|',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toCCAddressFormat_1.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') && toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //koma dan pipe
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('[\\|\\,]',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toCCAddress.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //koma dan pipe dan space
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toCCAddressFormat_1 = toCCAddress.replaceAll('[\\|\\,]',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toCCAddressFormat_1.split(';');
            }
            if(!toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && !toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && !toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',')){
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).split(';');
            }

        }

        if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName) != null){

            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ')){ //space
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toBCCAddress.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',')){ //koma
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\,',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toBCCAddress.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|')){ //pipe
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\|',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toBCCAddress.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //space dan koma
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toBCCAddressFormat_1 = toBCCAddress.replaceAll('\\,',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toBCCAddressFormat_1.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //space dan pipe
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toBCCAddressFormat_1 = toBCCAddress.replaceAll('\\|',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toBCCAddressFormat_1.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') && toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //koma dan pipe
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('[\\|\\,]',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toBCCAddress.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //koma dan pipe dan space
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toBCCAddressFormat_1 = toBCCAddress.replaceAll('[\\|\\,]',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toBCCAddressFormat_1.split(';');
            }
            if(!toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && !toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && !toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',')){
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).split(';');
            }

        }

        if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List.isEmpty()) {
            for(String Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_2_Result : Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List){
                if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_2_Result != null || Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_2_Result != ''){
                    Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET.add(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_2_Result);
                }
            }
        }

        if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List.isEmpty()) {
            for(String Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_2_Result : Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List){
                if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_2_Result != null || Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_2_Result != ''){
                    Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET.add(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_2_Result);
                }
            }
        }

        if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List.isEmpty()) {
            for(String Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_2_Result : Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_List){
                if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_2_Result != null || Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_2_Result != ''){
                    Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_2_SET.add(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_2_Result);
                }
            }
        }
    }

    Public Void Extract_Email_3_TerminationNonAutoRenewal_Setting(String settingName){
        Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = new List<String>();
        Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = new List<String>();
        Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = new List<String>();

        Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET = new Set<String>();
        Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET = new Set<String>();
        Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET = new Set<String>();

        if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName) != null){

            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ')){ //space
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toAddress.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',')){ //koma
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\,',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toAddress.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|')){ //pipe
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\|',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toAddress.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //space dan koma
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toAddressFormat_1 = toAddress.replaceAll('\\,',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toAddressFormat_1.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //space dan pipe
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toAddressFormat_1 = toAddress.replaceAll('\\|',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toAddressFormat_1.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') && toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //koma dan pipe
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('[\\|\\,]',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toAddress.split(';');
            }
            if(toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //koma dan pipe dan space
                String toAddress = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toAddressFormat_1 = toAddress.replaceAll('[\\|\\,]',';');
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toAddressFormat_1.split(';');
            }
            if(!toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && !toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && !toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){
                Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).split(';');
            }

        }

        if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName) != null){

            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ')){ //space
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toCCAddress.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',')){ //koma
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\,',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toCCAddress.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|')){ //pipe
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\|',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toCCAddress.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //space dan koma
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toCCAddressFormat_1 = toCCAddress.replaceAll('\\,',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toCCAddressFormat_1.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //space dan pipe
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toCCAddressFormat_1 = toCCAddress.replaceAll('\\|',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toCCAddressFormat_1.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') && toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //koma dan pipe
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('[\\|\\,]',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toCCAddress.split(';');
            }
            if(toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //koma dan pipe dan space
                String toCCAddress = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toCCAddressFormat_1 = toCCAddress.replaceAll('[\\|\\,]',';');
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toCCAddressFormat_1.split(';');
            }
            if(!toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && !toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && !toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',')){
                Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).split(';');
            }

        }

        if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName) != null){

            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ')){ //space
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toBCCAddress.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',')){ //koma
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\,',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toBCCAddress.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|')){ //pipe
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\|',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toBCCAddress.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //space dan koma
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toBCCAddressFormat_1 = toBCCAddress.replaceAll('\\,',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toBCCAddressFormat_1.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //space dan pipe
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toBCCAddressFormat_1 = toBCCAddress.replaceAll('\\|',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toBCCAddressFormat_1.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') && toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') ){ //koma dan pipe
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('[\\|\\,]',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toBCCAddress.split(';');
            }
            if(toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',') ){ //koma dan pipe dan space
                String toBCCAddress = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).replaceAll('\\s','');
                String toBCCAddressFormat_1 = toBCCAddress.replaceAll('[\\|\\,]',';');
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toBCCAddressFormat_1.split(';');
            }
            if(!toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(' ') && !toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains('|') && !toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).contains(',')){
                Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List = toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Map.get(settingName).split(';');
            }

        }

        if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List!=null && !Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List.isEmpty()) {
            for(String Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_3_Result : Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List){
                if(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_3_Result != null || Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_3_Result != ''){
                    Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET.add(Extract_toAddress_EmailTerminationNonAutoRenewal_Setting_3_Result);
                }
            }
        }

        if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List!=null && !Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List.isEmpty()) {
            for(String Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_3_Result : Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List){
                if(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_3_Result != null || Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_3_Result != ''){
                    Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET.add(Extract_toCCAddress_EmailTerminationNonAutoRenewal_Setting_3_Result);
                }
            }
        }

        if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List!=null && !Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List.isEmpty()) {
            for(String Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_3_Result : Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_List){
                if(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_3_Result != null || Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_3_Result != ''){
                    Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_Result_3_SET.add(Extract_toBCCAddress_EmailTerminationNonAutoRenewal_Setting_3_Result);
                }
            }
        }
    }

}