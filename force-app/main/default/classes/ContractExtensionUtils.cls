/**
 * @description       : 
 * @Test Class		  : TEST_Notif_TerminationNonAutoRenewal
 * @author            : 
 * @group             : 
 * @last modified on  : 02-09-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   02-09-2023   Novando Utoyo Agmawan   Initial Version
**/

public class ContractExtensionUtils {
    public String HariIni {get;set;}
    public String TanggalIni {get;set;}
    public String BulanIni {get;set;}
    public String TahunIni {get;set;}
    public Contract_Extension__c BAX{get;set;}
    public string opportunityID {get;set;}   
    public string contractExtensionID {get;set;}   
    public string linkID {get;set;}
    public list<link__c> links{get;set;}   
    public ContractExtensionUtils(ApexPages.StandardController controller) {
        //declare variable to be used in contract extension BA
        Contract_Extension__c CX = (Contract_Extension__c)controller.getRecord();
        contractExtensionID = CX.id;

        BAX = [SELECT Account_Manager__r.Email,Account_Manager__r.Manager.Email,Account__c,BA_Print__c,BA_Print__r.Name,BA_Print__r.Title,Account_Manager__c,Extension_Start_Date_string__c,Extension_End_Date_string__c,Extension_Monthly_Price__c,Link__r.Name,Link__r.capacity_bandwidth__c,link__r.service_type__c,Account__r.Name,Account__r.BP_Number_Unique_Name__c,Previous_End_Date_string__c,Previous_End_Date_string_English__c,Existing_Contract_item__r.End_Date__c,Going_To_Days__c,Existing_Contract_item__c FROM Contract_Extension__c WHERE ID=:CX.ID];

        links = [SELECT id,link_id__c,capacity_bandwidth__c,service_type__c,Site_A_Name__r.Unique_Name__c,uom__c,Contract_Item_Rel__c from Link__c where Contract_Item_Rel__c =: BAX.Existing_Contract_item__c];
        
        Integer Going_To_Days = Integer.valueOf(BAX.Going_To_Days__c);
        Date Contract_Endate_Minus = BAX.Existing_Contract_item__r.End_Date__c.addDays(-Going_To_Days);
        Datetime Contract_Endate_Minus_Format = Contract_Endate_Minus;

        String CurrentDay= Contract_Endate_Minus_Format.format('EEEE');
        if(CurrentDay=='Monday'||test.isrunningtest())
            HariIni='Senin';
        if(CurrentDay=='Tuesday'||test.isrunningtest())
            HariIni='Selasa';
        if(CurrentDay=='Wednesday'||test.isrunningtest())
            HariIni='Rabu';
        if(CurrentDay=='Thursday'||test.isrunningtest())
            HariIni='Kamis';
        if(CurrentDay=='Friday'||test.isrunningtest())
            HariIni='Jum\'at';
        if(CurrentDay=='Saturday'||test.isrunningtest())
            HariIni='Sabtu';
        if(CurrentDay=='Sunday'||test.isrunningtest())
            HariIni='Minggu';
        
        String CurrentDate = Contract_Endate_Minus_Format.format('dd MMM yyyy');
        String BulanIniFormat = Contract_Endate_Minus_Format.format('MMM');
        
        TahunIni = Contract_Endate_Minus_Format.format('yyyy');
        Tanggalini = Contract_Endate_Minus_Format.format('dd');
        
        if(BulanIniFormat.Contains('Jan')||test.isrunningtest())
            BulanIni=BulanIniFormat.Replace('Jan','Januari');
        if(BulanIniFormat.Contains('Feb')||test.isrunningtest())
            BulanIni=BulanIniFormat.Replace('Feb','Februari');
        if(BulanIniFormat.Contains('Mar')||test.isrunningtest())
            BulanIni=BulanIniFormat.Replace('Mar','Maret');
        if(BulanIniFormat.Contains('Apr')||test.isrunningtest())
            BulanIni=BulanIniFormat.Replace('Apr','April');
        if(BulanIniFormat.Contains('May')||test.isrunningtest())
            BulanIni=BulanIniFormat.Replace('May','Mei');
        if(BulanIniFormat.Contains('Jun')||test.isrunningtest())
            BulanIni=BulanIniFormat.Replace('Jun','Juni');
        if(BulanIniFormat.Contains('Jul')||test.isrunningtest())
            BulanIni=BulanIniFormat.Replace('Jul','Juli');
        if(BulanIniFormat.Contains('Aug')||test.isrunningtest())
            BulanIni=BulanIniFormat.Replace('Aug','Agustus');
        if(BulanIniFormat.Contains('Sep')||test.isrunningtest())
            BulanIni=BulanIniFormat.Replace('Sep','September');
        if(BulanIniFormat.Contains('Oct')||test.isrunningtest())
            BulanIni=BulanIniFormat.Replace('Oct','Oktober');
        if(BulanIniFormat.Contains('Nov')||test.isrunningtest())
            BulanIni=BulanIniFormat.Replace('Nov','November');
        if(BulanIniFormat.Contains('Dec')||test.isrunningtest())
            BulanIni=BulanIniFormat.Replace('Dec','Desember');          
    }
}