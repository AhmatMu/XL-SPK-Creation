/**
 * @description       : 
 * @author            : -
 * @group             : 
 * @last modified on  : 09-29-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   09-12-2022   Novando Utoyo Agmawan   Initial Version
**/

@isTest 
private class TestHitSoapAccountContact {
    static testMethod void myUnitTestNotBP() {
        Trigger_Controller__c TriggerController = new Trigger_Controller__c(Name = 'Trigger_Account', Is_Active__c = True );
        insert TriggerController;
        
        ACR_Roles_Configuration__c  ACRRolesConfig = new ACR_Roles_Configuration__c (name='PIC Site', api_name__c='PIC Site', sap_code__c='0012', priority__c =1); 
        insert ACRRolesConfig;

        ACRRolesConfig = new ACR_Roles_Configuration__c (name='PIC BA Recipient', api_name__c='PIC BA Recipient', sap_code__c='0016', priority__c =1); 
        insert ACRRolesConfig;

        ACRRolesConfig = new ACR_Roles_Configuration__c (name='PIC BA Print', api_name__c='PIC BA Print', sap_code__c='0017', priority__c =1);
        insert ACRRolesConfig;

        ACRRolesConfig = new ACR_Roles_Configuration__c (name='PIC Recipient Invoice', api_name__c='PIC UP Invoice', sap_code__c='0018', priority__c =2);
        insert ACRRolesConfig;

        ACRRolesConfig = new ACR_Roles_Configuration__c (name='Kadiv/Div. Head', api_name__c='PIC BA Sign', sap_code__c='0019', priority__c =1);
        insert ACRRolesConfig;

        ACRRolesConfig = new ACR_Roles_Configuration__c (name='PIC Print Invoice', api_name__c='PIC Print Invoice', sap_code__c='0020', priority__c =1);
        insert ACRRolesConfig;
        
        // TO DO: implement unit test
        Test.setMock(WebServiceMock.class, new CustomerContactTestWebServiceMock());
        
        insert new Transaction__c(
            transactionID__c = 125,
            Temporary_LA_or_IDCom__c = 2499
            );

        id accBPRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Account accParent=new Account();
        accParent.Name='asdX Account';
        accParent.recordtypeid = accBPRecType;
        accParent.Organization_Type__c = 'Head Office';
        accParent.Customer_Type__c  = 'NONGSM';
        accParent.Keyword__c='Xasd Acc';
        accParent.No_NPWP__c='123456789011322';
        accParent.BillingStreet='X Street';
        accParent.BillingCity='X City';
        accParent.BillingPostalCode='2444';
        accParent.LA_Number__c='1111';
        accParent.term_of_payment__c='Z030 Within 30 Days Due Net';
        accParent.BP_Number__c='020292';
        accParent.Field_Source__c = 'Bizstore Customer Registration';
        accParent.Bizstore_Complete__c = false;
        insert accParent;
        
        id accLARecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('LA').getRecordTypeId();
        Account A=new Account();
        A.Name='X Account';
        a.recordtypeid = accLARecType;
        A.Keyword__c='X Acc';
        A.No_NPWP__c='123456789011324';
        a.Organization_Type__c = 'Branch';
        a.ParentId = accParent.id;
        a.Customer_Type__c  = 'MADS';
        A.BillingStreet='ASDSDX Street';
        A.BillingCity='XASDDS City';
        A.BillingPostalCode='2444';
        A.LA_Number__c='12512334';
        A.term_of_payment__c='Z030 Within 30 Days Due Net';
        //A.BP_Number__c='020292';
        A.Field_Source__c = 'Bizstore Customer Registration';
        A.Bizstore_Complete__c = false;
        insert A;
        
        A.LA_Number__c='12123123';
        A.BillingCountry='Indonesia';
        //A.BP_Number__c='0202921';
        update A;

        profile p=[SELECT id FROM Profile WHERE Name='Sales'];
        user u=[SELECT id from user WHERE Profileid=:p.id AND isActive=true AND Employee_id__c!=null AND Employee_id__c!='' LIMIT 1];
        A.Ownerid=u.id;
        update A;

        Contact C=new Contact();
        C.FirstName='X';
        C.LastName='Zero';
        C.Email='XZero@gmail.com';
        C.Phone='02184877555';
        C.MobilePhone='087262622';
        C.Accountid=A.id;
        insert C;

        AccountContactRelation ACR=[SELECT Id,Roles FROM AccountContactRelation WHERE Accountid=:A.id AND ContactID=:C.id];
        ACR.Roles='PIC BA Print;PIC BA Print;PIC BA Recipient;';
        update ACR;

        ACR.Roles='PIC Print Invoice';
        update ACR;

        C.PIC_ID__c='10';
        update C;

        /*HitsapComDocumentSapSoap.insertaccount2(A.id);
        HitsapComDocumentSapSoap.updateaccountchangeowner(A.id,A.ownerid,A.ownerid);
        HitsapComDocumentSapSoap.updateaccount2(A.id,true,'222','222');*/

        HitsapComDocumentSapSoap.DeleteContact(C.id,A.id,'PIC BA Print','I');
        HitsapComDocumentSapSoap.insertContact2(C.id,A.id,'PIC BA Print','I');
        HitsapComDocumentSapSoap.UpdateContact2(C.id,A.id,'PIC BA Print','U');
    }

    static testMethod void myUnitTestBP() {
        Trigger_Controller__c TriggerController = new Trigger_Controller__c(Name = 'Trigger_Account', Is_Active__c = True );
        insert TriggerController;
        
        ACR_Roles_Configuration__c  ACRRolesConfig = new ACR_Roles_Configuration__c (name='PIC Site', api_name__c='PIC Site', sap_code__c='0012', priority__c =1); 
        insert ACRRolesConfig;

        ACRRolesConfig = new ACR_Roles_Configuration__c (name='PIC BA Recipient', api_name__c='PIC BA Recipient', sap_code__c='0016', priority__c =1); 
        insert ACRRolesConfig;

        ACRRolesConfig = new ACR_Roles_Configuration__c (name='PIC BA Print', api_name__c='PIC BA Print', sap_code__c='0017', priority__c =1);
        insert ACRRolesConfig;

        ACRRolesConfig = new ACR_Roles_Configuration__c (name='PIC Recipient Invoice', api_name__c='PIC UP Invoice', sap_code__c='0018', priority__c =2);
        insert ACRRolesConfig;

        ACRRolesConfig = new ACR_Roles_Configuration__c (name='Kadiv/Div. Head', api_name__c='PIC BA Sign', sap_code__c='0019', priority__c =1);
        insert ACRRolesConfig;

        ACRRolesConfig = new ACR_Roles_Configuration__c (name='PIC Print Invoice', api_name__c='PIC Print Invoice', sap_code__c='0020', priority__c =1);
        insert ACRRolesConfig;
        
        // TO DO: implement unit test
        Test.setMock(WebServiceMock.class, new CustomerContactTestWebServiceMock());
        
        insert new Transaction__c(
            transactionID__c = 125,
            Temporary_LA_or_IDCom__c = 2499
            );
        
        id accBPRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        Account A=new Account();
        A.Name='X Account';
        a.recordtypeid = accBPRecType;
        a.Organization_Type__c = 'Head Office';
        a.Customer_Type__c  = 'NONGSM';
        A.Keyword__c='X Acc';
        A.No_NPWP__c='123456789011329';
        A.BillingStreet='X Street';
        A.BillingCity='X City';
        A.BillingPostalCode='2444';
        //A.LA_Number__c='909812123';
        A.term_of_payment__c='Z030 Within 30 Days Due Net';
        A.BP_Number__c='020292';
        A.Field_Source__c = 'Bizstore Customer Registration';
        A.Bizstore_Complete__c = false;
        insert A;
        
        //A.LA_Number__c='2222';
        A.BillingCountry='Indonesia';
        A.BP_Number__c='0202921';
        update A;

        profile p=[SELECT id FROM Profile WHERE Name='Sales'];
        user u=[SELECT id from user WHERE Profileid=:p.id AND isActive=true AND Employee_id__c!=null AND Employee_id__c!='' LIMIT 1];
        A.Ownerid=u.id;
        update A;

        Contact C=new Contact();
        C.FirstName='X';
        C.LastName='Zero';
        C.Email='XZero@gmail.com';
        C.Phone='02184877555';
        C.MobilePhone='087262622';
        C.Accountid=A.id;
        insert C;

        AccountContactRelation ACR=[SELECT Id,Roles FROM AccountContactRelation WHERE Accountid=:A.id AND ContactID=:C.id];
        ACR.Roles='PIC BA Print;PIC BA Print;PIC BA Recipient;';
        update ACR;

        ACR.Roles='PIC Print Invoice';
        update ACR;

        C.PIC_ID__c='10';
        update C;

        /*HitsapComDocumentSapSoap.insertaccount2(A.id);
        HitsapComDocumentSapSoap.updateaccountchangeowner(A.id,A.ownerid,A.ownerid);
        HitsapComDocumentSapSoap.updateaccount2(A.id,true,'222','222');*/

        HitsapComDocumentSapSoap.DeleteContact(C.id,A.id,'PIC BA Print','I');
        HitsapComDocumentSapSoap.insertContact2(C.id,A.id,'PIC BA Print','I');
        HitsapComDocumentSapSoap.UpdateContact2(C.id,A.id,'PIC BA Print','U');
    }

    static testMethod void TestApproval(){
        /*profile p=[SELECT id FROM Profile WHERE Name='Sales'];
        user u=[SELECT id from user WHERE Profileid=:p.id AND isActive=true AND Employee_id__c!=null AND Employee_id__c!='' LIMIT 1];
        profile p2=[SELECT id FROM Profile WHERE Name='System Administrator'];
        user u2=[SELECT id from user WHERE Profileid=:p2.id AND isActive=true AND Employee_id__c!=null AND Employee_id__c!='' LIMIT 1];
        Account A=new Account();
        insert new Transaction__c(transactionID__c = 5);
        A.Name='X Account';
        A.Keyword__c='X Acc';
        A.No_NPWP__c='877222';
        A.BillingStreet='X Street';
        A.BillingCity='X City';
        A.BillingPostalCode='2444';
        A.term_of_payment__c='Z060 Within 60 Days Due Net';
        A.Top_Reason__c='Fail';
        A.BP_Number__c='020292';
        insert A;
        ProcessInstanceWorkItem piwi=[SELECT id FROM  ProcessInstanceWorkItem Order by Createddate DESC LIMIT 1];
        system.runas(u2){
        Approval.ProcessWorkItemRequest req2=new Approval.ProcessWorkItemRequest();
        req2.setAction('Reject');
        req2.setcomments('Tes');
        req2.setWorkitemId(piwi.id);
        Approval.ProcessResult result2 = Approval.process(req2);
        }*/ 
    }
}