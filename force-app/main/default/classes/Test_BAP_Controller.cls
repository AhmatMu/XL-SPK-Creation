@isTest
private class Test_BAP_Controller  {

     static testMethod void myUnitTestBAPController() {
        Test.startTest();

        BAP__c bap = new BAP__c();
        bap.type_of_request__c ='Pemutusan';
        bap.customer__c ='0017F00000RM06IQAT';
        bap.Link__c='a077F000003X0ILQA0';
        bap.sirkit__c='testbro';
        bap.pic_name__c ='do';
        bap.pic_phone__c ='de';
        bap.pic_position__c='PIC UP Invoice;PIC CS,';
        bap.pic_email__c='do@gmail.com';
        bap.bandwidth__c=3;
        bap.Bandwidth_UOM__c='Mbps';
        bap.request_date__c=date.newInstance(2018, 4, 21);
        bap.terminate_date__c = date.newInstance(2018, 5, 21);
        bap.reason__c ='Rekonfigurasi';
        bap.note__C ='note';
        bap.bap_status__c='approved';
        bap.approval_status__c = 'Need GM Sales Approval';
        bap.approval_iom__c = '';
        bap.remark__c ='remark';
        bap.request_status__C='Draft';
        bap.bap_id__c='1234567890';
        
        insert bap;
        //BAP__c> bapstmp = [select id from bap__C where sirkit__c='testbro'];
        list<BAP__c> bapstmp = [select id from bap__C where sirkit__c='testbro'];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(bap);
        BAP_Controller bapControllerObj = new BAP_Controller(sc); //Instantiate the Class        
        bapControllerObj.singleApprove();
        bapControllerObj.reset();
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(bapstmp );
        bapControllerObj = new BAP_Controller(ssc); //Instantiate the Class        
        bapControllerObj.selectedApprove();
        
        integer selectedSize = bapControllerObj.getMySelectedSize();
        integer recordSize = bapControllerObj.getMyRecordsSize();
        
        
        Test.stopTest();
     }


}