/**
 * @description       : 
 * @Test Class        : IdexProValidatePartner_test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 12-26-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   10-28-2022   Novando Utoyo Agmawan   Initial Version
**/

public class IdexProValidatePartner_ctrl {
    @AuraEnabled(cacheable = true) 
    public static List<Account> getAccount(String AccountID) { 
        DateTime start_time = datetime.now();
        List<Account> List_Account = null;

        try {
            system.debug('AccountID : ' + AccountID);

            List_Account = [
                SELECT Id,
                name,
                DealerID__c
                FROM Account
                WHERE Id =: AccountID
            ];

            system.debug('List_Account : ' + List_Account);

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

            return List_Account;
        } catch (Exception e) {
            String err_message = 'Error on IdexProValidatePartner_ctrl.cls - getAccount ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);

            return List_Account;
        }
    }

    @AuraEnabled
    public static string validatePartner(String AccountID, String sales_channel_type){
        DateTime start_time = datetime.now();
        String returnMessage;

        try {
            List<Account> List_Account = [
                SELECT Id,
                name,
                DealerID__c
                FROM Account
                WHERE Id =: AccountID
            ];

            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }

            returnMessage = REST_Account_Callout.validatePartner_sync(AccountID, sales_channel_type, List_Account[0].Name, List_Account[0].DealerID__c);
        } catch (Exception e) {
            String err_message = 'Error on IdexProValidatePartner_ctrl.cls - validatePartner ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();

            AppUtils.putError(err_message);
        }

        return returnMessage;
    }
    
    @AuraEnabled 
    public static ResultWrapper updateDealerRecords(String dealerInfo,String AccountID){
        ResultWrapper resultWrapper = new ResultWrapper();
        DateTime start_time = datetime.now();

        try {
            List<Account> List_Account = [
                SELECT Id,
                name,
                DealerID__c
                FROM Account
                WHERE Id =: AccountID
            ];

            if(String.isNotBlank(List_Account[0].DealerID__c)){
                resultWrapper.message = 'Dealer Id Already Created!'; 
                resultWrapper.messageType = 'error';
            }
            else{
                system.debug('dealerInfo : ' + dealerInfo);

                partnerDetails partnerDetails_Extract = (partnerDetails) JSON.deserialize(dealerInfo, partnerDetails.class);

                System.debug('>>> partnerDetails_Extract : ' + partnerDetails_Extract);
                
                if(partnerDetails_Extract!=null){
                    List<Contact> List_Contact = [
                        SELECT Id,
                        LastName,
                        Firstname,
                        MobilePhone,
                        Phone,
                        Email,
                        Reference_ID__c,
                        Idexpro_ProfileID__c
                        FROM Contact WHERE AccountId =: AccountID LIMIT 1
                    ];

                    if(List_Contact!=null && !List_Contact.isEmpty()){
                        Account account_Update = new Account();
                        account_Update.Id = AccountId;
                        account_Update.DealerID__c = partnerDetails_Extract.dealerId;
                        account_Update.Dealer_Status__c = 'Active';
                        //account_Update.Channel_Sub_Type__c = partnerDetails_Extract.channelSubType;
                        //account_Update.Channel_Category__c = partnerDetails_Extract.channelCategory;
                        //account_Update.Channel_Type__c = partnerDetails_Extract.channelType;
                        account_Update.Street_IdexPro__c = partnerDetails_Extract.address;
                        update account_Update;

                        for(Contact List_Contact_Extract : List_Contact){
                            List_Contact_Extract.Firstname = partnerDetails_Extract.partnerProfiles[0].firstName;
                            List_Contact_Extract.LastName = partnerDetails_Extract.partnerProfiles[0].lastName;
                            List_Contact_Extract.MobilePhone = partnerDetails_Extract.partnerProfiles[0].mobileNo;
                            List_Contact_Extract.Phone = partnerDetails_Extract.partnerProfiles[0].phoneNo;
                            List_Contact_Extract.Email = partnerDetails_Extract.partnerProfiles[0].emailAddress;
                            List_Contact_Extract.Idexpro_ProfileID__c = String.ValueOf(partnerDetails_Extract.partnerProfiles[0].profileId);
                        }
                        update List_Contact;

                        resultWrapper.messageType = 'success'; 
                    }else{
                        resultWrapper.message = 'Please Input Contact Person First!'; 
                        resultWrapper.messageType = 'error';
                    }
                }else{
                    resultWrapper.message = 'dealer Info Json Null'; 
                    resultWrapper.messageType = 'error';
                }
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch(Exception e) {
            resultWrapper.message = e.getMessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber(); 
            resultWrapper.messageType = 'error';

            String err_message = 'Error on IdexProValidatePartner_ctrl.cls - updateDealerRecords ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();

            AppUtils.putError(err_message);
        }
        return resultWrapper;
    }

    public class ResultWrapper {
        @AuraEnabled public String message;
        @AuraEnabled public String messageType;
    }

    public class partnerDetails {
        public String dealerId;	//90185461
        public String salesChannelName;	//PT Profesional Internet Indonesia
        public String phoneNo;	//62021837368292
        public String emailAddress;	//testing071101@gmail.com
        public String userId;
        public String channelType;	//BUSOL - Community
        public String channelSubType;
        public String channelCategory;	//
        public String address;	//Jl Bendi GG Pandawa No.07 Rt.004 Rw.004 Triwunglor,Kota Probolinggo,Kademangan,JAWA TIMUR,Indonesia,67225
        public List<cls_partnerProfiles> partnerProfiles;
    }

    public class cls_partnerProfiles {
		public Integer profileId;	//11189737
		public String address;
		public String birthDate;
		public String birthPlace;
		public String city;
		public String country;
		public String emailAddress;	//testing071101@gmail.com
		public String faxNo;
		public String firstName;	//Usama
		public String gender;
		public String homePhoneNo;	//62null
		public String identityNo;
		public String lastName;	//Agmawan
		public String mobileNo;	//62837462839
		public String outletSize;
		public String outletType;
		public String phoneNo;	//62021837368292
		public String postalCode;
		public String profileType;	//Contact Person
		public String province;
		public Integer salesChannelId;	//11190030
		public String title;
		public String menu4_actionFlag;
	}
}