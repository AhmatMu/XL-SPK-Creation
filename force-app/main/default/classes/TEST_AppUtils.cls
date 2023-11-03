/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 02-02-2023
 * @last modified by  : Novando Utoyo Agmawan
**/

@isTest(seealldata=true)
public class TEST_AppUtils {
    
    static testMethod void testMthod1() {
        
        //AppUtils AppUtil = new AppUtils();
        String JSONStringInput ='{"Body":{"operation":"Customer Profile","transactionId":"1234","status":"1","entity":"AFI","service":"getCustomerInfo","IcAx_AXAAsiaCustomer_Type":{"processedDttm":"2016-10-28T19:14:05","canBeIndividual":{"genderCD":"F","hasAddressesIn":[{"addressLine4":"Indonesia Raya","addressLine3":"Indonesia","addressLine2":"jakarta selatan","addressLine1":"kebayoran baru"}],"birthPlace":"Jakarta","birthDT":"19800327"},"hasPolicyAccount":[{"hasPartyDetailsIn":[{"canBeIndividual":{"hasPartyAccountDetailsIn":{"payorLastNM":"Bagus","branchCD":"Jakarta","rejectCD":"A1","accountEffectiveDT":"20100727","accountTypeCD":"1040002003189","accountStatusCD":"active","bankName":"Mandiri","accountNO":"104000200318","accountExpirationDT":"20150727","rejectDT":"20161026","payorFirstNM":"Bagus"}},"servicingCD":"000373","producingCD":"0003737"}],"policyNO":"100-103-0000038"},{"hasPartyDetailsIn":[{"canBeIndividual":{"hasPartyAccountDetailsIn":{"payorLastNM":"Bagus","branchCD":"Jakarta","rejectCD":"A1","accountEffectiveDT":"20100727","accountTypeCD":"1040002003189","accountStatusCD":"active","bankName":"Mandiri","accountNO":"104000200318","accountExpirationDT":"20150727","rejectDT":"20161026","payorFirstNM":"Bagus"}},"servicingCD":"000373","producingCD":"0003737"}],"policyNO":"100-103-0000038"}],"customerID":"000000000093836"},"appID":"RLS","AXAAsiaPagination_Type":{"rowPerPage":"","numberOfRecords":"","startDateTime":"","pageNumber":"","endDateTime":"","startOfRecords":""}}}';
        String JSONStringOutput='';
        
        Test.startTest();
        

        JSONStringOutput = AppUtils.stripJsonNulls(JSONStringInput);
        system.debug('JSONStringOutput : ' + JSONStringOutput);
        
        Map<String, Object> m = new Map<String, Object>();
        m = AppUtils.getMapPackageFromJSON (JSONStringOutput);
        
        String status = AppUtils.getStringDataOnMap(m, 'Body::status');
        
        String addressLine4 = AppUtils.getStringDataOnMap(m, 'Body::IcAx_AXAAsiaCustomer_Type::canBeIndividual::hasAddressesIn[0]::addressLine4');
        
        
        List<Object> lo = AppUtils.getListDataOnMap(m, 'Body::IcAx_AXAAsiaCustomer_Type::hasPolicyAccount') ;
        
        Date d1 = AppUtils.strToDate('20160101', '');
        Date d2 = AppUtils.strToDate('2016-01-01', 'yyyy-mm-dd');
        Date d3 = AppUtils.strToDate('20160101', 'yyyymmdd');
        Date d4 = AppUtils.strToDate('2016/01/01', 'yyyy/mm/dd');
        Date d5 = AppUtils.strToDate('2016/01/01', '--');
        
        Date d6 = AppUtils.strToDate('', 'yyyymmdd');
        Date d7 = AppUtils.strToDate('', 'yyyy/mm/dd');

        DateTime dt1 = AppUtils.strToDateTime('20160101', '');
        DateTime dt2 = AppUtils.strToDateTime('2016-01-01', 'yyyy-mm-dd');
        DateTime dt3 = AppUtils.strToDateTime('20160101', 'yyyymmdd');
        DateTime dt4 = AppUtils.strToDateTime('2016-01-01 10:11:12', 'yyyy-mm-dd hh:mm:ss');
        DateTime dt5 = AppUtils.strToDateTime('20160101103112', 'yyyymmddhhmmss');
        
        DateTime dt6 = AppUtils.strToDateTime('', 'yyyy-mm-dd');
        DateTime dt7 = AppUtils.strToDateTime('', 'yyyymmdd');
        DateTime dt8 = AppUtils.strToDateTime('', 'yyyy-mm-dd hh:mm:ss');
        DateTime dt9 = AppUtils.strToDateTime('', 'yyyymmddhhmmss');

        
        Date bd = AppUtils.strToDate('19781010', 'yyyymmdd');
        string age = AppUtils.birthToAge( bd);
        string age1 = AppUtils.birthToAge( null);
        
        decimal dc1 = AppUtils.strToDec('10.10'); 
        
        string guid = AppUtils.getNewGUID() ;
        string unmr = AppUtils.getUniqueNumber();
        string sessionID = AppUtils.getSessionID();    
        
        string en = AppUtils.doEncrypt('hello');
        string de = AppUtils.doDecrypt(en );

        AppUtils.putError('AA::BB::CC');

        AppUtils.putCalllog(null,null,datetime.now(),'status',datetime.now(),'requestMessage','responseMessage');

        AppUtils.nextDate(system.today(),1,true,true,true);
        
        List<ContentVersion> csv = AppUtils.getOpportunityFilesOnBase64('0067F000008iaAz') ;

		Map<String, Object> paramMap = (Map<String, Object>) JSON.deserializeUntyped('{"header":{"service":"addapn","request_id":"657878986879"},"body":{"data":{"apn_id":"1","apn_name":"APN 1"}}}');
		system.debug('============ paramMap  : ' + paramMap );
        Map<string, Object> mapRec = (Map<string, Object>) appUtils.getObjectDataOnMap(paramMap,'body::data');
                   

		Datetime dt = appUtils.addHours(system.now(), 2);
		decimal dc = appUtils.getDecimalOrNull ('90.8');
		string ss = appUtils.getStringOrNull ('hello') ;
		Boolean bb = appUtils.isKeysetNotFound ('== Keyset NOT found ==');
		
		// gettoken
		SingleRequestMock getToken = new SingleRequestMock(200,
                                                         'success',
                                                         '{"token":"2345678908765435467890"}',
                                                         null);
        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Label.REST_TransDB_GetToken_Endpoint, getToken);
        HttpCalloutMock multiCalloutMock =
            	                   new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
		string token = appUtils.getToken(label.REST_TransDB_GetToken_Endpoint, label.REST_TransDB_GetToken_Username, label.REST_TransDB_GetToken_Password, 1) ;
		
		
		//-- test
		Date lastContractStartDate = Date.newInstance(2017, 1, 1);
		Date lastContractEndDate = Date.newInstance(2017, 12, 31);
		Integer ContractTerm = 6;
		Date newContractStartDate = Date.newInstance(2019, 2, 1);
		
		date newContractEndDate = apputils.getNewContractEndDate (lastContractStartDate, lastContractEndDate, ContractTerm, newContractStartDate,'Month',5,'Month'); 

        List<Profitability_Recordtype_Controller__c> List_ProfitabilityRecordtypeController = [SELECT Name, Product_Code__c FROM Profitability_Recordtype_Controller__c];

		//-- test lock opportunity 
		List <opportunity> opps = [select id , Opportunity_ID__c from opportunity order by createddate asc limit 2 ] ;
		List <string> oppids = new List <string>(); 
		for (Opportunity opp : opps) {
			oppids.add (opp.Opportunity_ID__c);
		}
        apputils.lockOpportunities(oppids);
        apputils.randomStringAll(5);
        AppUtils.terbilang(5);
        AppUtils.terbilang(15);
        AppUtils.terbilang(80);
        AppUtils.terbilang(100);
        AppUtils.terbilang(1000);
        AppUtils.terbilang(2000);
        AppUtils.terbilang(1000000);
        AppUtils.terbilang_Inggris(5);
        AppUtils.terbilang_Inggris(21);
        AppUtils.terbilang_Inggris(100);
        AppUtils.terbilang_Inggris(125);
        AppUtils.terbilang_Inggris(1000);
        AppUtils.terbilang_Inggris(1025);

        AppUtils.get_userID('HEAD_SALES','0');
        AppUtils.get_userID('GH_SALES','0');
        AppUtils.get_userID('CEO Enterprise and SME','');


        AppUtils.getDateMonthName_FORMAT_MMM_ID(Date.valueOf('2021-01-01'));
        AppUtils.getDateMonthName_FORMAT_MMM_ID(Date.valueOf('2021-02-02'));
        AppUtils.getDateMonthName_FORMAT_MMM_ID(Date.valueOf('2021-03-03'));
        AppUtils.getDateMonthName_FORMAT_MMM_ID(Date.valueOf('2021-04-04'));
        AppUtils.getDateMonthName_FORMAT_MMM_ID(Date.valueOf('2021-05-05'));
        AppUtils.getDateMonthName_FORMAT_MMM_ID(Date.valueOf('2021-06-06'));
        AppUtils.getDateMonthName_FORMAT_MMM_ID(Date.valueOf('2021-07-07'));
        AppUtils.getDateMonthName_FORMAT_MMM_ID(Date.valueOf('2021-08-08'));
        AppUtils.getDateMonthName_FORMAT_MMM_ID(Date.valueOf('2021-09-09'));
        AppUtils.getDateMonthName_FORMAT_MMM_ID(Date.valueOf('2021-10-10'));
        AppUtils.getDateMonthName_FORMAT_MMM_ID(Date.valueOf('2021-11-11'));
        AppUtils.getDateMonthName_FORMAT_MMM_ID(Date.valueOf('2021-12-12'));
        
        AppUtils.getDateMonthName_FORMAT_MMM_EN(Date.valueOf('2021-01-01'));
        AppUtils.getDateMonthName_FORMAT_MMM_EN(Date.valueOf('2021-02-02'));
        AppUtils.getDateMonthName_FORMAT_MMM_EN(Date.valueOf('2021-03-03'));
        AppUtils.getDateMonthName_FORMAT_MMM_EN(Date.valueOf('2021-04-04'));
        AppUtils.getDateMonthName_FORMAT_MMM_EN(Date.valueOf('2021-05-05'));
        AppUtils.getDateMonthName_FORMAT_MMM_EN(Date.valueOf('2021-06-06'));
        AppUtils.getDateMonthName_FORMAT_MMM_EN(Date.valueOf('2021-07-07'));
        AppUtils.getDateMonthName_FORMAT_MMM_EN(Date.valueOf('2021-08-08'));
        AppUtils.getDateMonthName_FORMAT_MMM_EN(Date.valueOf('2021-09-09'));
        AppUtils.getDateMonthName_FORMAT_MMM_EN(Date.valueOf('2021-10-10'));
        AppUtils.getDateMonthName_FORMAT_MMM_EN(Date.valueOf('2021-11-11'));
        AppUtils.getDateMonthName_FORMAT_MMM_EN(Date.valueOf('2021-12-12'));
		//----			

        AppUtils.getDateMonthName_FORMAT_MM_ID(Date.valueOf('2021-01-01'));
        AppUtils.getDateMonthName_FORMAT_MM_ID(Date.valueOf('2021-02-02'));
        AppUtils.getDateMonthName_FORMAT_MM_ID(Date.valueOf('2021-03-03'));
        AppUtils.getDateMonthName_FORMAT_MM_ID(Date.valueOf('2021-04-04'));
        AppUtils.getDateMonthName_FORMAT_MM_ID(Date.valueOf('2021-05-05'));
        AppUtils.getDateMonthName_FORMAT_MM_ID(Date.valueOf('2021-06-06'));
        AppUtils.getDateMonthName_FORMAT_MM_ID(Date.valueOf('2021-07-07'));
        AppUtils.getDateMonthName_FORMAT_MM_ID(Date.valueOf('2021-08-08'));
        AppUtils.getDateMonthName_FORMAT_MM_ID(Date.valueOf('2021-09-09'));
        AppUtils.getDateMonthName_FORMAT_MM_ID(Date.valueOf('2021-10-10'));
        AppUtils.getDateMonthName_FORMAT_MM_ID(Date.valueOf('2021-11-11'));
        AppUtils.getDateMonthName_FORMAT_MM_ID(Date.valueOf('2021-12-12'));

        AppUtils.getDateMonthName_FORMAT_MM_EN(Date.valueOf('2021-01-01'));
        AppUtils.getDateMonthName_FORMAT_MM_EN(Date.valueOf('2021-02-02'));
        AppUtils.getDateMonthName_FORMAT_MM_EN(Date.valueOf('2021-03-03'));
        AppUtils.getDateMonthName_FORMAT_MM_EN(Date.valueOf('2021-04-04'));
        AppUtils.getDateMonthName_FORMAT_MM_EN(Date.valueOf('2021-05-05'));
        AppUtils.getDateMonthName_FORMAT_MM_EN(Date.valueOf('2021-06-06'));
        AppUtils.getDateMonthName_FORMAT_MM_EN(Date.valueOf('2021-07-07'));
        AppUtils.getDateMonthName_FORMAT_MM_EN(Date.valueOf('2021-08-08'));
        AppUtils.getDateMonthName_FORMAT_MM_EN(Date.valueOf('2021-09-09'));
        AppUtils.getDateMonthName_FORMAT_MM_EN(Date.valueOf('2021-10-10'));
        AppUtils.getDateMonthName_FORMAT_MM_EN(Date.valueOf('2021-11-11'));
        AppUtils.getDateMonthName_FORMAT_MM_EN(Date.valueOf('2021-12-12'));
		 
        AppUtils.weekOfMonth(Date.valueOf('2021-12-12'));
        AppUtils.weekOfYear(datetime.newInstanceGmt(2021, 07, 05));

        AppUtils.generateApprovalURL('0017F00000RM9fyQAD');
        AppUtils.generateApprovalURL('0017F00002giWG7QAM');
        AppUtils.additionalSettingEmail('diky.nurosid@saasten.com.invalid,ahmat.murad@saasten.invalid');
        AppUtils.getProductCodeFromOpptyLineProduct(oppids);
        AppUtils.getProfitability_RecordtypeController('LL');
        AppUtils.getNumberSuffix(1);
        Test.stopTest();
    }
    
}