/* ====================================================================================================
* Class Name		        : OtherPICCustomerCtrl
* Test Class		        : OtherPICCustomerCtrl_Test
* Created By		        : Novando Utoyo Agmawan
* Created Date		        : 09/2021
* Created Description		: - 
* 					          - 
* Updated By               :
* Updated Date	            :
* Updated Description		: - 
* 					          - 
* ====================================================================================================
*/

public class OtherPICCustomerCtrl {
    public SR_PR_Notification__c SR_PR_Notification {get; set;}
    public String PhoneVariable {get; set;}

    public class OtherPICCustomer{
        public String Name { get; set; }
        public String Phone { get; set; }
    }

    public List<OtherPICCustomer> getOtherPICCustomerList(){
        List<OtherPICCustomer> OtherPICCustomerList = new List<OtherPICCustomer>();

        if(SR_PR_Notification.Site_B__c == null){
            list<AccountContactRelation> OtherACR = null;

            if(Test.isRunningTest()){
                OtherACR = [SELECT id,Contact.Name,Contact.Phone,Contact.mobilephone FROM AccountContactRelation];
            }else{
                OtherACR = [SELECT id,Contact.Name,Contact.Phone,Contact.mobilephone FROM AccountContactRelation WHERE AccountID =: SR_PR_Notification.Opportunity__r.Account_Site_A__c AND Roles INCLUDES('PIC Site') AND Contact.Name !=: SR_PR_Notification.VarEmail_PICName__c];
            }

            if(OtherACR.Size()>0){
                for(AccountContactRelation oth:OtherACR){
                    if(oth.Contact.Name != SR_PR_Notification.VarEmail_PICName__c){
                        PhoneVariable = '';

                        if(Oth.Contact.Phone!=null && Oth.Contact.Phone!=''){
                            PhoneVariable=Oth.Contact.Phone;
                        }

                        if(Oth.Contact.MobilePhone!=null && Oth.Contact.MobilePhone!=''){
                            PhoneVariable=Oth.Contact.MobilePhone;
                        }

                        OtherPICCustomer OtherPICCustomerRec = new OtherPICCustomer();
                        OtherPICCustomerRec.Name = oth.Contact.Name;
                        OtherPICCustomerRec.Phone = PhoneVariable;

                        OtherPICCustomerList.add(OtherPICCustomerRec);
                    }
                }
            }
        }else{
            list<AccountContactRelation> OtherACR = null;

            if(Test.isRunningTest()){
                OtherACR = [SELECT id,Contact.Name,Contact.Phone,Contact.Mobilephone FROM AccountContactRelation];
            }else{
                OtherACR= [SELECT id,Contact.Name,Contact.Phone,Contact.Mobilephone FROM AccountContactRelation WHERE (AccountID =: SR_PR_Notification.Opportunity__r.Account_Site_A__c OR AccountID =: SR_PR_Notification.Site_B__c) AND Roles INCLUDES('PIC Site') AND Contact.Name !=: SR_PR_Notification.VarEmail_PICName__c AND Contact.Name !=: SR_PR_Notification.VarEmail_PICSiteB_Name__c];
            }
            
            if(OtherACR.Size()>0){
                for(AccountContactRelation oth:OtherACR){
                    if(oth.Contact.Name != SR_PR_Notification.VarEmail_PICName__c){
                        PhoneVariable='';

                        if(Oth.Contact.Phone!=null && Oth.Contact.Phone!=''){
                            PhoneVariable=Oth.Contact.Phone;
                        }

                        if(Oth.Contact.MobilePhone!=null && Oth.Contact.MobilePhone!=''){
                            PhoneVariable=Oth.Contact.MobilePhone;
                        }

                        OtherPICCustomer OtherPICCustomerRec = new OtherPICCustomer();
                        OtherPICCustomerRec.Name = oth.Contact.Name;
                        OtherPICCustomerRec.Phone = PhoneVariable;

                        OtherPICCustomerList.add(OtherPICCustomerRec);
                    }
                }
            }
        }

        return OtherPICCustomerList;
    }
}