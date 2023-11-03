/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-14-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class PresurveyDataFactory {
	@testVisible    
    private static String generateRandomString(Integer len) {
        final String chars = 'xaxPmno2IDdEwLzbtEvhv6oG1RDT6xQJX3MvF4amaDQ9TUvHgJfdbodlllPTnnuw';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
    @testVisible
    private static String generateRandomNumber(Integer len) {
        final String chars = '0129875346';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }   
    
    /*
    public static User generateNewUser(Profile pf, String uniqueLastname){
        String orgId=UserInfo.getOrganizationId();
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        String uniqueName=orgId+dateString+generateRandomNumber(3) ;
        
        User usr = new User(firstname = generateRandomString(6), 
                           lastName = uniqueLastname, 
                           email = uniqueLastname+'@xl.co.id', 
                           Username = uniqueName + '@test' + orgId + '.org', 
                           EmailEncodingKey = 'ISO-8859-1', 
                           Alias = uniqueName.substring(18, 23), 
                           TimeZoneSidKey = 'America/Los_Angeles', 
                           LocaleSidKey = 'en_US', 
                           LanguageLocaleKey = 'en_US', 
                           ProfileId = pf.Id
                          ); 
        return usr;
    }
    
   
    public static List<Account> generateTestAccount(Integer numRecords, Id userid){
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
        List<Account> accnts = new List<Account>();
        Integer bpRandom = Integer.valueOf(generateRandomNumber(5));
        for(Integer counter = 1; counter <= numRecords; counter++){
            bpRandom = bpRandom+counter;
            Account accTest = new Account();
            accTest.OwnerId = userid;
            accTest.RecordTypeId = recordTypeId_accBP;
            accTest.Name = 'PT. Test '+generateRandomString(20);
            accTest.Unique_Name__c = generateRandomString(10);
            accTest.NumberOfEmployees = 2;
            accTest.Summary_Billing__c = false;
            accTest.Payer_For_GSM_Invoice__c = false;
            accTest.Using_HO_Billing_Address__c = false;
            //accTest.Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)';
            accTest.Customer_VAT_Name__c = accTest.Name;
            accTest.Customer_Type__c = 'NONGSM';
            accTest.No_NPWP__c = generateRandomNumber(15);
            accTest.BillingStreet = generateRandomString(30);
            accTest.BillingState = generateRandomString(8);
            accTest.BillingCity = generateRandomString(10);
            accTest.BillingCountry = 'Indonesia';
            //accTest.BillingPostalCode = 'hive';
            accTest.ShippingStreet = generateRandomString(30);
            accTest.ShippingState = generateRandomString(8);
            accTest.ShippingCity = generateRandomString(10);
            accTest.ShippingCountry = 'Indonesia';
            //accTest.ShippingPostalCode = 'hive';
            //accTest.Billing_Building_Name__c = 'hive';
            //accTest.Shipping_Building_Name__c = 'hive';
            //accTest.Field_Source__c = 'Bizstore Customer Registration';
            accTest.Organization_Type__c = 'Head Office';
            accTest.Type = 'Customer';
            accTest.term_of_payment__c = 'Z030 Within 30 Days Due Net';
            //accTest.OU__c = '1';
            accTest.Industry = 'Agriculture';
            accTest.BP_Number__c = String.valueOf(bpRandom);
            accTest.Bizstore_Complete__c = false;
        }
        return accnts;
    }
    
    public static Account generateTestAccount( Id userid){
        Id recordTypeId_accBP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();        
        Integer bpRandom = Integer.valueOf(generateRandomNumber(5));       
        Account accTest = new Account();
        accTest.OwnerId = userid;
        accTest.RecordTypeId = recordTypeId_accBP;
        accTest.Name = 'PT. Test '+generateRandomString(20);
        accTest.Unique_Name__c = generateRandomString(10);
        accTest.NumberOfEmployees = 2;
        accTest.Summary_Billing__c = false;
        accTest.Payer_For_GSM_Invoice__c = false;
        accTest.Using_HO_Billing_Address__c = false;
        //accTest.Company_Group__c = 'BANK INTERNATIONAL INDONESIA TBK, PT (BII)';
        accTest.Customer_VAT_Name__c = accTest.Name;
        accTest.Customer_Type__c = 'NONGSM';
        accTest.No_NPWP__c = generateRandomNumber(15);
        accTest.BillingStreet = generateRandomString(30);
        accTest.BillingState = generateRandomString(8);
        accTest.BillingCity = generateRandomString(10);
        accTest.BillingCountry = 'Indonesia';
        //accTest.BillingPostalCode = 'hive';
        accTest.ShippingStreet = generateRandomString(30);
        accTest.ShippingState = generateRandomString(8);
        accTest.ShippingCity = generateRandomString(10);
        accTest.ShippingCountry = 'Indonesia';
        //accTest.ShippingPostalCode = 'hive';
        //accTest.Billing_Building_Name__c = 'hive';
        //accTest.Shipping_Building_Name__c = 'hive';
        //accTest.Field_Source__c = 'Bizstore Customer Registration';
        accTest.Organization_Type__c = 'Head Office';
        accTest.Type = 'Customer';
        accTest.term_of_payment__c = 'Z030 Within 30 Days Due Net';
        //accTest.OU__c = '1';
        accTest.Industry = 'Agriculture';
        accTest.BP_Number__c = String.valueOf(bpRandom);
        accTest.Bizstore_Complete__c = false;
        
        return accTest;
    }
    
    public static List<Presurvey__c> generateNewPresurvey(Integer numRecords, Id userid){
        
        List<Presurvey__c> listPresurvey = new List<Presurvey__c>();
        
        for(Integer counter = 1; counter <= numRecords; counter++ ){
            Presurvey__c presurvey = new Presurvey__c();
            presurvey.Customer_Name__c = generateRandomString(15);
            presurvey.OwnerId = userid;
            presurvey.Capacity__c = 10;
            presurvey.UoM_Capacity__c = 'Mbps';
            presurvey.Presurvey_Status__c = 'Draft';
            presurvey.Customer_Requirement__c = 'For Test Purposed Only.\nTestNumber : '+counter;
            presurvey.Service_Group__c = 'NON GSM';
            presurvey.Service__c = 'MPLS';
            presurvey.Province_Site_A__c = 'Sumatera Selatan';
            presurvey.City_Site_A__c = 'Kabupaten Musi Banyuasin';
            presurvey.Location_Site_A__c = generateRandomString(40);
            listPresurvey.add(presurvey);
        }        
        return listPresurvey;
    }*/
    
    public static Presurvey__c generateNewPresurvey(Id userid){       
        
        Presurvey__c presurvey = new Presurvey__c();
        presurvey.Customer_Name__c = generateRandomString(15);
        presurvey.OwnerId = userid;
        presurvey.Capacity__c = 10;
        presurvey.UoM_Capacity__c = 'Mbps';
        presurvey.Presurvey_Status__c = 'Draft';
        presurvey.Customer_Requirement__c = 'For Test Purposed Only.\nSingleRecord';
        presurvey.Service_Group__c = 'NON GSM';
        presurvey.Service__c = 'MPLS';
        presurvey.Province_Site_A__c = 'Sumatera Selatan';
        presurvey.City_Site_A__c = 'Kabupaten Musi Banyuasin';
        presurvey.Coordinate_Site_A__Latitude__s=0;
        presurvey.Coordinate_Site_A__Longitude__s=113.867569;
        presurvey.Coordinate_Site_B__Latitude__s=0;
        presurvey.Coordinate_Site_B__Longitude__s=113.867569;
        presurvey.Location_Site_A__c = generateRandomString(40);     
              
        return presurvey;
    }
    /*
    public static List<Presurvey__c> generateNewPresurveyWithAccount(Integer numRecords, Account acc, Id userid){
        
        List<Presurvey__c> listPresurvey = new List<Presurvey__c>();
        
        for(Integer counter = 1; counter <= numRecords; counter++ ){
            Presurvey__c presurvey = new Presurvey__c();
            presurvey.Customer_Name__c = acc.Name;
            presurvey.OwnerId = userid;
            presurvey.Account__c = acc.Id;
            presurvey.Capacity__c = 10;
            presurvey.UoM_Capacity__c = 'Mbps';
            presurvey.Presurvey_Status__c = 'Draft';
            presurvey.Customer_Requirement__c = 'For Test Purposed Only.\nTestNumber : '+counter;
            presurvey.Service_Group__c = 'NON GSM';
            presurvey.Service__c = 'MPLS';
            presurvey.Province_Site_A__c = 'Sumatera Selatan';
            presurvey.City_Site_A__c = 'Kabupaten Musi Banyuasin';
            presurvey.Location_Site_A__c = generateRandomString(40);
            listPresurvey.add(presurvey);
        }        
        return listPresurvey;
    }*/
    
    public static Presurvey__c generateNewPresurveyWithAccount( Account acc, Id userid){
        
        Presurvey__c presurvey = new Presurvey__c();
        presurvey.Customer_Name__c = acc.Name;
        presurvey.OwnerId = userid;
        presurvey.Account__c = acc.Id;
        presurvey.Capacity__c = 10;
        presurvey.UoM_Capacity__c = 'Mbps';
        presurvey.Presurvey_Status__c = 'Draft';
        presurvey.Customer_Requirement__c = 'For Test Purposed Only.\nSingleRecord ';
        presurvey.Service_Group__c = 'NON GSM';
        presurvey.Service__c = 'MPLS';
        presurvey.Province_Site_A__c = 'Sumatera Selatan';
        presurvey.Coordinate_Site_A__Latitude__s=0;
        presurvey.Coordinate_Site_A__Longitude__s=113.867569;
        presurvey.Coordinate_Site_B__Latitude__s=0;
        presurvey.Coordinate_Site_B__Longitude__s=113.867569;
        presurvey.City_Site_A__c = 'Kabupaten Musi Banyuasin';
        presurvey.Need_Tower_Candidate_Site_A__c=false;
        presurvey.Need_Tower_Candidate_Site_B__c=true;
        presurvey.Location_Site_A__c = generateRandomString(40);
            
        return presurvey;
    }


    
    
}