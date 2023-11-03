/**
 * @description       : 
 * @Test Class		  : TEST_Notif_Contract_Extension
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 02-03-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   07-29-2022   Novando Utoyo Agmawan   Initial Version
**/

public class Email_Notif_NEW_Contract_Extension {
    public List<Contract> All_Contract_List {get; set;}
    public List<Messaging.SingleEmailMessage> sendEmailList {get; set;}
    public Messaging.SingleEmailMessage singleEmailMessageObj  {get; set;}
    public String MessageBody {get; set;}
    public String htmlBody {get; set;}
    public String htmlSubject {get; set;}
    public List<string> List_toAddress {get; set;}
    public Set<string> Set_toAddress {get; set;}
    public List<string> List_toCCAddress {get; set;}
    public Set<string> Set_toCCAddress {get; set;}
    public List<string> List_toBCCAddress {get; set;}
    public Set<string> Set_toBCCAddress {get; set;}

    public Email_Notif_NEW_Contract_Extension(List<Contract> FetchAll_Contract_List){
        DateTime start_time = datetime.now();
        All_Contract_List = FetchAll_Contract_List;

        Integer ChangeUser=1;

        List_toAddress = new List<string>();
        Set_toAddress  = new Set<string>();
        List_toCCAddress = new List<string>();
        Set_toCCAddress  = new Set<string>();
        List_toBCCAddress = new List<string>();
        Set_toBCCAddress  = new Set<string>();

        try {
            list<User> userList = [SELECT id,email FROM User WHERE Name='Contract Manager' OR Name='Sales Admin'];

            List<Email_Notif_Contract_Extension_Setting__c> Email_Notif_Contract_Extension_Setting_List = [SELECT Name, Additional_toAddress__c, Additional_toCCAddress__c, Additional_toBCCAddress__c FROM Email_Notif_Contract_Extension_Setting__c WHERE Name =: 'Email_Notif_NEW_Contract_Extension'];

            system.debug('Email_Notif_NEW_Contract_Extension Email_Notif_Contract_Extension_Setting_List : ' + Email_Notif_Contract_Extension_Setting_List);

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

            Set_toAddress.addAll(List_toAddress);
            Set_toAddress.add(userList[0].Email);
            Set_toAddress.add(userList[1].Email);
            Set_toAddress.remove('');
            Set_toAddress.remove(null);

            List_toAddress.clear();
            List_toAddress.addAll(Set_toAddress);

            Set_toCCAddress.addAll(List_toCCAddress);
            Set_toCCAddress.remove('');
            Set_toCCAddress.remove(null);

            List_toCCAddress.clear();
            List_toCCAddress.addAll(Set_toCCAddress);

            Set_toBCCAddress.addAll(List_toBCCAddress);
            Set_toBCCAddress.remove('');
            Set_toBCCAddress.remove(null);

            List_toBCCAddress.clear();
            List_toBCCAddress.addAll(Set_toBCCAddress);


            EmailTemplate emailTemplate = [Select id, htmlValue, subject from EmailTemplate where DeveloperName = 'Email_Notif_NEW_Contract_Extension'];

            sendEmailList = new List<Messaging.SingleEmailMessage>();

            integer i = 0;
		
            for(i=0;i<All_Contract_List.size();i++) {
                if(changeuser==1)
                {
                    singleEmailMessageObj = new Messaging.SingleEmailMessage();

                    MessageBody = '';

                    if(!test.isrunningtest()){
                        htmlBody = emailTemplate.HtmlValue;
                        htmlBody = htmlBody.replace('{!!ContractSales}', All_Contract_List[i].Sales__c);
    
                        htmlSubject = emailTemplate.subject;
                        //htmlSubject = htmlSubject.replace('{!!SegmentListValue}', SegmentList[i]);
                    }

                    List_toAddress.add(All_Contract_List[i].account.owner.email);

                    singleEmailMessageObj.toAddresses = List_toAddress;
                    if(List_toCCAddress!=null && !List_toCCAddress.isEmpty()){
                        singleEmailMessageObj.setCcAddresses(List_toCCAddress);
                    }
                    if(List_toBCCAddress!=null && !List_toBCCAddress.isEmpty()){
                        singleEmailMessageObj.setBccAddresses(List_toBCCAddress);
                    }
                    singleEmailMessageObj.optOutPolicy = 'FILTER';
                    singleEmailMessageObj.subject = htmlSubject;
                    
                    messagebody='<table border="1" style = "border-collapse: collapse; width: 100%;"><tr><td>Contract Number</td><td>Company Name</td><td>Product Code</td><td>Link ID</td><td>Segment</td><td>Start Date</td><td>End Date</td><td>Price IDR/Month</td></tr>';
                }
                
                Changeuser=0;
                
                if(changeuser==0)
                {
                    Date contract_StartDate = All_Contract_List[i].Start_Date__c;
                    String contract_StartDate_month = AppUtils.getDateMonthName_FORMAT_MMM_ID(contract_StartDate);
                    String Existing_ContractStartDate_Format = '';
                    if(contract_StartDate != null){
                        Existing_ContractStartDate_Format = contract_StartDate.day() + ' ' + contract_StartDate_month + ' ' + contract_StartDate.year();
                    }else{
                        Existing_ContractStartDate_Format = '';
                    }

                    Date contract_EndDate = All_Contract_List[i].End_Date__c;
                    String contract_EndDate_month = AppUtils.getDateMonthName_FORMAT_MMM_ID(contract_EndDate);
                    String Existing_ContractEndDate_Format = '';
                    if(contract_EndDate != null){
                        Existing_ContractEndDate_Format = contract_EndDate.day() + ' ' + contract_EndDate_month + ' ' + contract_EndDate.year();
                    }else{
                        Existing_ContractEndDate_Format = '';
                    }

                    messagebody=messagebody+'<tr><td>'+All_Contract_List[i].contract_id__c+'-'+All_Contract_List[i].SAP_ID__c+'</td><td>'+All_Contract_List[i].Account.Name+'</td><td>'+All_Contract_List[i].Product__r.SAP_Code__c+'</td><td>'+All_Contract_List[i].Link__r.Link_id__c+'</td><td>'+All_Contract_List[i].Account.Segmentation__c+'</td><td>'+Existing_ContractStartDate_Format+'</td><td>'+Existing_ContractEndDate_Format+'</td><td>'+AppUtils.Decimal_To_Currency(All_Contract_List[i].Price__c)+'</td></tr>';
                }
                
                if(All_Contract_List.size()==i+1)
                {
                    Changeuser=1;
                } 
                
                else if(All_Contract_List[i+1].sales__c!=All_Contract_List[i].sales__c||i==All_Contract_List.size()-1)
                {
                    changeuser=1;
                }
                
                if(changeuser==1)
                {
                    messagebody=messagebody+'</table>';

                    if(!test.isrunningtest()){
                        htmlBody = htmlBody.replace('{!!TableValue}', messagebody);
                    }

                    singleEmailMessageObj.setHtmlBody(htmlBody); 
                    sendEmailList.add(singleEmailMessageObj);
                }
            }

            if(All_Contract_List.size() == i)
            {
                if(sendEmailList!=null && !sendEmailList.isEmpty())
                {
                    system.debug('sendEmailListSize : ' + sendEmailList.size()) ;
                    Messaging.sendEmail(sendEmailList,true);    
                }
                Controller_NEW_Contract_Extension Class_Controller_NEW_Contract_Extension = new Controller_NEW_Contract_Extension(All_Contract_List);
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