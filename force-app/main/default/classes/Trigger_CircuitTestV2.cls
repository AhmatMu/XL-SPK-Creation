/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed 
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@isTest(seealldata = false)
private class Trigger_CircuitTestV2 {
    //
    static testMethod void myUnitTest() {
        Trigger_Controller__c triggerControllerSetting = new Trigger_Controller__c();
        triggerControllerSetting.Name = 'CircuitTrigger.beforeInsert';
        triggerControllerSetting.Is_Active__c = true;
        insert triggerControllerSetting;
        
        Trigger_Controller__c triggerControllerSettings = new Trigger_Controller__c();
        triggerControllerSettings.Name = 'CircuitTrigger';
        triggerControllerSettings.Is_Active__c = true;
        insert triggerControllerSettings;
        
        ServiceSetting__c serviceSettings = new ServiceSetting__c();
        serviceSettings.Name = 'ISP';
        serviceSettings.CircuitLastCounterNumber__c = 0;
        serviceSettings.CircuitPrefixName__c = '0';
        insert serviceSettings;
        // TO DO: implement unit test
        //insert new Link_CID__c(CID_4GACCESS__c = 1);
        Circuit__c cir = new Circuit__c();
        cir.Name = 'Auto';
        cir.Services__c = 'ISP';
        insert cir;
        
    }  
    /* static testMethod void myUnitTest2() {
// TO DO: implement unit test
//insert new Link_CID__c(CID_4GACCESS__c = 1);
Circuit__c cir2 = new Circuit__c();
cir2.Name = 'Auto';
//cir.Services__c = '4G Access';
insert cir2;

}
*/
    /*
static testMethod void myUnitTest2() {
//insert new Link_CID__c(CID_4GACCESS__c = 1);
//insert new Link_CID__c(CID_HPABX__c = 1);
//insert new Link_CID__c(CID_ISPHRB__c = 1);
//insert new Link_CID__c(CID_MPLSWAN__c = 1);
//insert new Link_CID__c(CID_NAPXLIX__c = 1);
//insert new Link_CID__c(CID_SMSB__c = 1);
//insert new Link_CID__c(CID_SSLVPN__c = 1);
//insert new Link_CID__c(CID_VCON__c = 1);
//insert new Link_CID__c(CID_WEB2SMS__c = 1);
//insert new Link_CID__c(CID_APN__c = 1);
//insert new Link_CID__c(CID_CL__c = 1);
//insert new Link_CID__c(CID_FLEET__c = 1);
//insert new Link_CID__c(CID_GSMPBX__c = 1);
//insert new Link_CID__c(CID_IAAS__c = 1);
//insert new Link_CID__c(CID_ISP__c = 1);
//insert new Link_CID__c(CID_ISPFTTX__c = 1);
//insert new Link_CID__c(CID_ISPPROMO__c = 1);
//insert new Link_CID__c(CID_ISPUPTO__c  = 1);
//insert new Link_CID__c(CID_L2VPN__c    = 1);
//insert new Link_CID__c(CID_LL__c   = 1);
//insert new Link_CID__c(CID_MCA__c  = 1);
//insert new Link_CID__c(CID_MDS__c  = 1);
//insert new Link_CID__c(CID_MPLS__c     = 1);
//insert new Link_CID__c(CID_NAP__c  = 1);
//insert new Link_CID__c(CID_NAPMIX__c = 1);

Circuit__c cir_MPLS = new Circuit__c();
cir_MPLS.Services__c = 'MPLS';
insert cir_MPLS;
}

static testMethod void myUnitTest3() {
// TO DO: implement unit test
insert new Link_CID__c(CID_4GACCESS__c = 1);
Circuit__c cir_4G = new Circuit__c();
cir_4G.Services__c = '4G Access';
insert cir_4G;

}
*/
}