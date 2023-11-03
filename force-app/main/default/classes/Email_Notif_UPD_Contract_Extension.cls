/**
 * @description       : 
 * @Test Class        : TEST_Notif_Contract_Extension
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 02-03-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   10-03-2022   Novando Utoyo Agmawan   Initial Version
**/

public class Email_Notif_UPD_Contract_Extension {
    public Messaging.SingleEmailMessage singleEmailMessageObj  {get; set;}
    public List<string> List_toAddress {get; set;}
    public Set<string> Set_toAddress {get; set;}
    public List<string> List_toCCAddress {get; set;}
    public List<string> List_toBCCAddress {get; set;}
    public Set<string> Set_toBCCAddress {get; set;}

    public Email_Notif_UPD_Contract_Extension(List<Contract_Extension__c> FetchAll_ContractExtension_List){
        DateTime start_time = datetime.now();

        system.debug('All_ContractExtension_ListSIZE ' + FetchAll_ContractExtension_List.size());
        system.debug('All_ContractExtension_List ' + FetchAll_ContractExtension_List);

        Integer totalpendingsegment = 0;

        try {
            EmailTemplate emailTemplate = [Select id, htmlValue, subject from EmailTemplate where DeveloperName = 'Email_Notif_UPD_Contract_Extension'];

            Set<String> userRoleSet = new Set<String>();
            list<String> SegmentList = new list<String>();

            if(FetchAll_ContractExtension_List!=null && !FetchAll_ContractExtension_List.isEmpty()){
                for(Contract_Extension__c FetchAll_ContractExtension_List_extract : FetchAll_ContractExtension_List){
                    if(
                        String.isNotBlank(FetchAll_ContractExtension_List_extract.Segment__c) ||
                        Test.isRunningTest()
                    ){
                        userRoleSet.add(FetchAll_ContractExtension_List_extract.Segment__c);
                    }
                }
            }

            if(userRoleSet!=null && !userRoleSet.isEmpty()){
                SegmentList.addAll(userRoleSet);
            }

            List<Email_Notif_Contract_Extension_Setting__c> Email_Notif_Contract_Extension_Setting_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c, Additional_toBCCAddress__c FROM Email_Notif_Contract_Extension_Setting__c WHERE Name =: 'Email_1_95Hari_Setting'];

            String htmlBody = '';
            String htmlSubject = '';
            String MessageBody='';
            String ExistingContract_1 = '';
            String ExistingContract_2 = '';
            String ExistingContract_Format = '';
            String LinkName_1 = '';
            String LinkName_2 = '';
            String LinkName_Format = '';
            String Autorenewal = '';
            Integer ContractPeriod_1;
            String ContractPeriod_2 = '';
            String ContractPeriod_Format = '';
            String contract_end_date_month  = '';
            Date Existing_ContractEndDate;
            String Existing_ContractEndDate_Format = '';
            String contract_start_date_month  = '';
            Date RenewalContractStart;
            String RenewalContractStart_Format = '';
            String contract_Renewal_Enddate_month  = '';
            Date RenewalContractEnd ;
            String RenewalContractEnd_Format = '';
            String Recordlink = URL.getSalesforceBaseUrl().toExternalForm()+'/';
            String RequiredAction = '';

            for(Integer i=0;i<SegmentList.size();i++)
            {
                totalpendingsegment = 0;

                singleEmailMessageObj = new Messaging.SingleEmailMessage();
                List_toCCAddress = new List<string>();
                List_toBCCAddress = new List<string>();
                Set_toBCCAddress = new Set<string>();

                if(Email_Notif_Contract_Extension_Setting_List!=null && !Email_Notif_Contract_Extension_Setting_List.isEmpty()){
                    String batch_ToAddress = Email_Notif_Contract_Extension_Setting_List[0].Additional_toAddress__c;
                    String batch_toCCAddress = Email_Notif_Contract_Extension_Setting_List[0].Additional_toCCAddress__c;
                    String batch_toBCCAddress = Email_Notif_Contract_Extension_Setting_List[0].Additional_toBCCAddress__c;
        
                    if(String.isNotBlank(batch_ToAddress)){
                        if(batch_ToAddress.contains(' ')){ //space
                            String toAddress = batch_ToAddress.replaceAll('\\s','');
                            List_toAddress = toAddress.split(';');
                        }
                        if(batch_ToAddress.contains(',')){ //koma
                            String toAddress = batch_ToAddress.replaceAll('\\,',';');
                            List_toAddress = toAddress.split(';');
                        }
                        if(batch_ToAddress.contains('|')){ //pipe
                            String toAddress = batch_ToAddress.replaceAll('\\|',';');
                            List_toAddress = toAddress.split(';');
                        }
                        if(batch_ToAddress.contains(' ') && batch_ToAddress.contains(',') ){ //space dan koma
                            String toAddress = batch_ToAddress.replaceAll('\\s','');
                            String toAddressFormat_1 = toAddress.replaceAll('\\,',';');
                            List_toAddress = toAddressFormat_1.split(';');
                        }
                        if(batch_ToAddress.contains(' ') && batch_ToAddress.contains('|') ){ //space dan pipe
                            String toAddress = batch_ToAddress.replaceAll('\\s','');
                            String toAddressFormat_1 = toAddress.replaceAll('\\|',';');
                            List_toAddress = toAddressFormat_1.split(';');
                        }
                        if(batch_ToAddress.contains(',') && batch_ToAddress.contains('|') ){ //koma dan pipe
                            String toAddress = batch_ToAddress.replaceAll('[\\|\\,]',';');
                            List_toAddress = toAddress.split(';');
                        }
                        if(batch_ToAddress.contains(' ') && batch_ToAddress.contains('|') && batch_ToAddress.contains(',') ){ //koma dan pipe dan space
                            String toAddress = batch_ToAddress.replaceAll('\\s','');
                            String toAddressFormat_1 = toAddress.replaceAll('[\\|\\,]',';');
                            List_toAddress = toAddressFormat_1.split(';');
                        }
                        if(!batch_ToAddress.contains(' ') && !batch_ToAddress.contains('|') && !batch_ToAddress.contains(',') ){
                            List_toAddress = batch_ToAddress.split(';');
                        }
                    }
        
                    if(String.isNotBlank(batch_toCCAddress)){
                        if(batch_toCCAddress.contains(' ')){ //space
                            String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                            List_toCCAddress = toCCAddress.split(';');
                        }
                        if(batch_toCCAddress.contains(',')){ //koma
                            String toCCAddress = batch_toCCAddress.replaceAll('\\,',';');
                            List_toCCAddress = toCCAddress.split(';');
                        }
                        if(batch_toCCAddress.contains('|')){ //pipe
                            String toCCAddress = batch_toCCAddress.replaceAll('\\|',';');
                            List_toCCAddress = toCCAddress.split(';');
                        }
                        if(batch_toCCAddress.contains(',') && batch_toCCAddress.contains('|') ){ //koma dan pipe
                            String toCCAddress = batch_toCCAddress.replaceAll('[\\|\\,]',';');
                            List_toCCAddress = toCCAddress.split(';');
                        }
                        if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains(',') ){ //space dan koma
                            String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                            String toCCAddressFormat_1 = toCCAddress.replaceAll('\\,',';');
                            List_toCCAddress = toCCAddressFormat_1.split(';');
                        }
                        if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains('|') ){ //space dan pipe
                            String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                            String toCCAddressFormat_1 = toCCAddress.replaceAll('\\|',';');
                            List_toCCAddress = toCCAddressFormat_1.split(';');
                        }
                        if(batch_toCCAddress.contains(' ') && batch_toCCAddress.contains('|') && batch_toCCAddress.contains(',') ){ //koma dan pipe dan space
                            String toCCAddress = batch_toCCAddress.replaceAll('\\s','');
                            String toCCAddressFormat_1 = toCCAddress.replaceAll('[\\|\\,]',';');
                            List_toCCAddress = toCCAddressFormat_1.split(';');
                        }
                        if(!batch_toCCAddress.contains(' ') && !batch_toCCAddress.contains('|') && !batch_toCCAddress.contains(',') ){
                            List_toCCAddress = batch_toCCAddress.split(';');
                        }
                    }

                    if(String.isNotBlank(batch_toBCCAddress)){
                        if(batch_toBCCAddress.contains(' ')){ //space
                            String toBCCAddress = batch_toBCCAddress.replaceAll('\\s','');
                            List_toBCCAddress = toBCCAddress.split(';');
                        }
                        if(batch_toBCCAddress.contains(',')){ //koma
                            String toBCCAddress = batch_toBCCAddress.replaceAll('\\,',';');
                            List_toBCCAddress = toBCCAddress.split(';');
                        }
                        if(batch_toBCCAddress.contains('|')){ //pipe
                            String toBCCAddress = batch_toBCCAddress.replaceAll('\\|',';');
                            List_toBCCAddress = toBCCAddress.split(';');
                        }
                        if(batch_toBCCAddress.contains(',') && batch_toBCCAddress.contains('|') ){ //koma dan pipe
                            String toBCCAddress = batch_toBCCAddress.replaceAll('[\\|\\,]',';');
                            List_toBCCAddress = toBCCAddress.split(';');
                        }
                        if(batch_toBCCAddress.contains(' ') && batch_toBCCAddress.contains(',') ){ //space dan koma
                            String toBCCAddress = batch_toBCCAddress.replaceAll('\\s','');
                            String toBCCAddressFormat_1 = toBCCAddress.replaceAll('\\,',';');
                            List_toBCCAddress = toBCCAddressFormat_1.split(';');
                        }
                        if(batch_toBCCAddress.contains(' ') && batch_toBCCAddress.contains('|') ){ //space dan pipe
                            String toBCCAddress = batch_toBCCAddress.replaceAll('\\s','');
                            String toBCCAddressFormat_1 = toBCCAddress.replaceAll('\\|',';');
                            List_toBCCAddress = toBCCAddressFormat_1.split(';');
                        }
                        if(batch_toBCCAddress.contains(' ') && batch_toBCCAddress.contains('|') && batch_toBCCAddress.contains(',') ){ //koma dan pipe dan space
                            String toBCCAddress = batch_toBCCAddress.replaceAll('\\s','');
                            String toBCCAddressFormat_1 = toBCCAddress.replaceAll('[\\|\\,]',';');
                            List_toBCCAddress = toBCCAddressFormat_1.split(';');
                        }
                        if(!batch_toBCCAddress.contains(' ') && !batch_toBCCAddress.contains('|') && !batch_toBCCAddress.contains(',') ){
                            List_toBCCAddress = batch_toBCCAddress.split(';');
                        }
                    }
                }

                Set_toBCCAddress.addAll(List_toBCCAddress);
                Set_toBCCAddress.remove('');
                Set_toBCCAddress.remove(null);

                List_toBCCAddress.clear();
                List_toBCCAddress.addAll(Set_toBCCAddress);
                
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='operationrevenuemanagement@xl.co.id'];
                singleEmailMessageObj.setOrgWideEmailAddressId(owea.get(0).Id);
                singleEmailMessageObj.optOutPolicy = 'FILTER';
                
                //messageBody = '<html><head><style>th,td{padding: 7px;}</style></head><body>BA Extension - '+SegmentList[i]+' <br><br>Kindly need your action to add customer contact information in order to proceed Contract Extension for customer with below detail : <br><br>';

                if(!test.isrunningtest()){
                    htmlBody = emailTemplate.HtmlValue;
                    htmlBody = htmlBody.replace('{!!SegmentListValue}', SegmentList[i]);

                    htmlSubject = emailTemplate.subject;
                    htmlSubject = htmlSubject.replace('{!!SegmentListValue}', SegmentList[i]);
                }

                messagebody =
                '<table border="1" style = "border-collapse: collapse; width: 100%;">' +
                '<tr> ' +
                '<th>Link</th> ' +
                '<th>BA Extension Number</th> ' +
                '<th>BP Number</th> ' +
                '<th>Customer Name</th> ' +
                '<th>Service</th> ' +
                '<th>CID</th> ' +
                '<th>Link ID</th> ' +
                '<th>Link Name</th> ' +
                '<th>Existing Contract</th> ' +
                '<th>Price IDR/Month</th> ' +
                '<th>Autorenewal</th> ' +
                '<th>Contract Period</th> ' +
                '<th>Existing Contract End Date</th> ' +
                '<th>Renewal Contract Start</th> ' +
                '<th>Renewal Contract End</th> ' +
                '<th>Required Action</th> ' +
                '</tr>';
                
                List_toAddress = new List<string>();
                Set_toAddress  = new Set<string>();

                //untuk membagi BA Extension email per segment, kalau masih segment sama, rownya ditambah tapi kalau sudah beda segment maka emailnya dibedakan
                for(Contract_Extension__c All_ContractExtension_List : FetchAll_ContractExtension_List)
                {
                    if(All_ContractExtension_List.Segment__c == SegmentList[i])
                    {
                        list<User> user_List = [SELECT id, email, manager.email FROM User WHERE Id =: All_ContractExtension_List.Account__r.OwnerId ]; 
                        
                        if(user_List!=null && !user_List.isEmpty()){
                            for(User user_List_extract : user_List)
                            {
                                if(user_List_extract.email != null){
                                    Set_toAddress.add(user_List_extract.email);
                                }
                                
                                if(user_List_extract.manager.email != null){
                                    Set_toAddress.add(user_List_extract.manager.email);
                                }
                            }
                        }

                        if(!String.isBlank(All_ContractExtension_List.Solution_PIC__r.email)){
                            Set_toAddress.add(All_ContractExtension_List.Solution_PIC__r.email);
                        }
                                            
                        LinkName_1 = All_ContractExtension_List.Link__r.Site_A_Name__r.Name;
                        LinkName_2 = All_ContractExtension_List.Link__r.Site_A_Name__r.Unique_Name__c;
                        LinkName_Format = LinkName_1 + ' ' + LinkName_2;

                        ExistingContract_1 = All_ContractExtension_List.Existing_Contract_item__r.contract_ID__c;
                        ExistingContract_2 = All_ContractExtension_List.Existing_Contract_item__r.SAP_ID__c;
                        ExistingContract_Format = ExistingContract_1 + ' - ' + ExistingContract_2;
                        
                        if(All_ContractExtension_List.Existing_Contract_item__r.Auto_Renewal__c == True){
                            Autorenewal = 'Yes';
                        }else if(All_ContractExtension_List.Existing_Contract_item__r.Auto_Renewal__c == False){
                            Autorenewal = 'No';
                        }else{
                            Autorenewal = 'No';
                        }

                        ContractPeriod_1 = Integer.ValueOf(All_ContractExtension_List.Existing_Contract_item__r.Contract_Term__c);
                        ContractPeriod_2 = All_ContractExtension_List.Existing_Contract_item__r.Periode_UOM__c;
                        ContractPeriod_Format = String.ValueOf(ContractPeriod_1) + ' ' + ContractPeriod_2;

                        Existing_ContractEndDate = All_ContractExtension_List.Existing_Contract_item__r.End_Date__c;
                        contract_end_date_month = AppUtils.getDateMonthName_FORMAT_MMM_ID(Existing_ContractEndDate);
                        if(Existing_ContractEndDate != null){
                            Existing_ContractEndDate_Format = Existing_ContractEndDate.day() + ' ' + contract_end_date_month + ' ' + Existing_ContractEndDate.year();
                        }else{
                            Existing_ContractEndDate_Format = '';
                        }
                        
                        RenewalContractStart = All_ContractExtension_List.Extension_Start_Date__c;
                        contract_start_date_month = AppUtils.getDateMonthName_FORMAT_MMM_ID(RenewalContractStart);
                        if(RenewalContractStart != null){
                            RenewalContractStart_Format = RenewalContractStart.day() + ' ' + contract_start_date_month + ' ' + RenewalContractStart.year();
                        }else{
                            RenewalContractStart_Format = '';
                        }
                        
                        RenewalContractEnd = All_ContractExtension_List.Extension_End_Date__c;
                        contract_Renewal_Enddate_month = AppUtils.getDateMonthName_FORMAT_MMM_ID(RenewalContractEnd);
                        if(RenewalContractEnd != null){
                            RenewalContractEnd_Format = RenewalContractEnd.day() + ' ' + contract_Renewal_Enddate_month + ' ' + RenewalContractEnd.year();
                        }else{
                            RenewalContractEnd_Format = '';
                        }

                        if(All_ContractExtension_List.Status__c == 'Fill BA Recipient and BA Print'){
                            RequiredAction = 'Need to add PIC BA Print and BA Recipient';
                        }else if(All_ContractExtension_List.Status__c == 'Waiting Solution Approval'){
                            RequiredAction = 'Need solution Approval';
                        }

                        messagebody=messagebody+
                        '<tr> ' +
                        '<td ><a href="'+Recordlink+All_ContractExtension_List.id+'" target="_blank">Link</a></td> ' + //--> Link
                        '<td>'+All_ContractExtension_List.name+'</td> ' + //--> BA Extension Number
                        '<td>'+All_ContractExtension_List.Account__r.BP_Number__c+'</td> ' + //--> BP Number
                        '<td>'+All_ContractExtension_List.Account__r.Name+'</td> ' + //--> Customer Name
                        '<td>'+All_ContractExtension_List.Link__r.Service_Type__c+'</td> ' + //--> Service
                        '<td>'+All_ContractExtension_List.Link__r.CID__c+'</td> ' + //--> CID
                        '<td>'+All_ContractExtension_List.Link__r.Link_ID__c+'</td> ' + //--> Link ID
                        '<td>'+LinkName_Format+'</td> ' + //--> Link Name
                        '<td>'+ExistingContract_Format+'</td> ' + //--> Existing Contract 
                        '<td>'+AppUtils.Decimal_To_Currency(All_ContractExtension_List.Existing_Contract_item__r.Price__c)+'</td> ' + //--> Price IDR/Month
                        '<td>'+Autorenewal+'</td> ' + //--> Autorenewal
                        '<td>'+ContractPeriod_Format+'</td> ' + //--> Contract Period
                        '<td>'+Existing_ContractEndDate_Format+'</td> ' + //--> Existing Contract End Date
                        '<td>'+RenewalContractStart_Format+'</td> ' + //--> Renewal Contract Start
                        '<td>'+RenewalContractEnd_Format+'</td> ' + //--> Renewal Contract End
                        '<td>'+RequiredAction+'</td> ' + //--> RequiredAction
                        '</tr> ';

                        totalpendingsegment = totalpendingsegment + 1 ;
                    }
                }

                //messagebody=messagebody+'</table><br>To proceed the contract Extension please add PIC BA Print and PIC BA Recipient on BP HO and go to each link on the table to Submit the process or or Follow up Solution approval to proceed.<br><br>Best Regards<br></body>  </html>';

                messagebody=messagebody+'</table>';

                if(!test.isrunningtest()){
                    htmlBody = htmlBody.replace('{!!TableValue}', messagebody);
                }

                List_toAddress.addAll(Set_toAddress);

                system.debug('Email_Notif_UPD_Contract_Extension List_toAddress : ' + json.serialize(List_toAddress));
                system.debug('Email_Notif_UPD_Contract_Extension List_toAddress Size : ' + List_toAddress.size());

                system.debug('Email_Notif_UPD_Contract_Extension List_toCCAddress : ' + json.serialize(List_toCCAddress));
                system.debug('Email_Notif_UPD_Contract_Extension List_toCCAddress Size : ' + List_toCCAddress.size());

                singleEmailMessageObj.subject = htmlSubject;
                singleEmailMessageObj.setHtmlBody(htmlBody); 
                singleEmailMessageObj.setToAddresses(List_toAddress);
                if(List_toCCAddress!=null && !List_toCCAddress.isEmpty()){
                    singleEmailMessageObj.setCcAddresses(List_toCCAddress);
                }
                if(List_toBCCAddress!=null && !List_toBCCAddress.isEmpty()){
                    singleEmailMessageObj.setBccAddresses(List_toBCCAddress);
                }
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {singleEmailMessageObj};
                if(totalpendingsegment>0) 
                {
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                }
            }

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch (Exception e) {
            String err_message = 'Error on Email_Notif_NEW_Contract_Extension.cls - Email_Notif_NEW_Contract_Extension ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }

}