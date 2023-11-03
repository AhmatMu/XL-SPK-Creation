/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-20-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   10-20-2023   Novando Utoyo Agmawan   Initial Version
**/

@isTest(seeAllData=true)
private class TEST_Scheduled_Process_Services {
    

    private string cntID='';
    
    static testMethod void doScenario1Test() {
        // TO DO: implement unit test 
        test.starttest();
        
        
        Scheduled_Process__c  sp = new Scheduled_Process__c ();
        sp.type__c = 'Callout Contract';
        sp.status__c = 'Waiting';
        insert SP;

        Scheduled_Process_Services sps = new Scheduled_Process_Services();
        String sch = '0 0 23 * * ?';
        //  system.schedule('Test check', sch, sps);
        // sps.execute(null);
          Scheduled_Process__c  sp2 = new Scheduled_Process__c ();
        sp2.type__c = 'Callout Link';
        sp2.status__c = 'Waiting';
        insert SP2;

        Scheduled_Process_Services sps2 = new Scheduled_Process_Services();
        String sch2 = '0 0 23 * * ?';
        //    system.schedule('Test check2', sch2, sps2);
        //   sps2.execute(null);


        Scheduled_Process_Services sps3 = new Scheduled_Process_Services();
        String sch3 = '0 0 23 * * ?';
        //    system.schedule('Test check2', sch2, sps2);

        Scheduled_Process__c  sp3 = new Scheduled_Process__c ();
        sp3.type__c = 'Callout Account';
        sp3.status__c = 'Waiting';
        insert SP3;
        //     sps3.execute(null);
        Scheduled_Process_Services sps4 = new Scheduled_Process_Services();
        String sch4 = '0 0 23 * * ?';
        //    system.schedule('Test check2', sch2, sps2);

        Scheduled_Process__c  sp4 = new Scheduled_Process__c ();
        sp4.type__c = 'Replicate PR';
        sp4.status__c = 'Waiting';
        insert SP4;
        sps4.execute(null);


        //-- TAGGING 
        Scheduled_Process_Services sps5 = new Scheduled_Process_Services();
        String sch5 = '0 0 23 * * ?';
        Scheduled_Process__c  sp5 = new Scheduled_Process__c ();
        sp5.type__c = 'Callout GSMTagging';
        sp5.status__c = 'Waiting';
        sp5.Parameter2__c = '{"group_no":1, "data_limit":20}';
        insert sp5;
        sps5.scheduledProcessID = sp5.id;
        sps5.execute(null);


        //-- UNTAGGING 
        Scheduled_Process_Services sps6 = new Scheduled_Process_Services();
        String sch6 = '0 0 23 * * ?';
        Scheduled_Process__c  sp6 = new Scheduled_Process__c ();
        sp6.type__c = 'Callout GSMUnTagging';
        sp6.status__c = 'Waiting';
        sp6.Parameter2__c = '{"group_no":1, "data_limit":20}';
        insert sp6;
        sps6.scheduledProcessID = sp6.id;
        sps6.execute(null);


        //-- UNTAGGING CHECK
        Scheduled_Process_Services sps7 = new Scheduled_Process_Services();
        String sch7 = '0 0 23 * * ?';
        Scheduled_Process__c  sp7 = new Scheduled_Process__c ();
        sp7.type__c = 'Callout GSMTaggingCheck';
        sp7.status__c = 'Waiting';
        sp7.Parameter2__c = '{"group_no":1, "data_limit":20}';
        insert sp7;
        sps7.scheduledProcessID = sp7.id;
        sps7.execute(null);


        //-- UNTAGGING CHECK
        Scheduled_Process_Services sps8 = new Scheduled_Process_Services();
        String sch8 = '0 0 23 * * ?';
        Scheduled_Process__c  sp8 = new Scheduled_Process__c ();
        sp8.type__c = 'Callout GSMUnTaggingCheck';
        sp8.status__c = 'Waiting';
        sp8.Parameter2__c = '{"group_no":1, "data_limit":20}';
        insert sp8;
        sps8.scheduledProcessID = sp8.id;
        sps8.execute(null);


        //-- Check All Order_MSISDN Status
        Scheduled_Process_Services sps9 = new Scheduled_Process_Services();
        String sch9 = '0 0 23 * * ?';
        Scheduled_Process__c  sp9 = new Scheduled_Process__c ();
        sp9.type__c = 'Check All Order_MSISDN Status';
        sp9.status__c = 'Waiting';
        sp9.Parameter1__c = '8017F000006yhajQAA';
        insert sp9;
        sps9.scheduledProcessID = sp9.id;
        sps9.execute(null);
        
        
        test.stoptest();

     }       
}