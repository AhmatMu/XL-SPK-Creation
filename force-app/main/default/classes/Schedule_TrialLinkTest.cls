/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-18-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class Schedule_TrialLinkTest {
    @isTest static void runSchedule() {
        test.starttest();
        Circuit__c circuitRec = new Circuit__c(
            Name = '02-09679'   // CID
        );

        insert circuitRec;

        link__c linkRec = new link__c(
        Company_Name__c = 'PT BANK MANDIRI (PERSERO) Tbk',                                                                       // Company Name
        Capacity_Bandwidth__c = '1',                                                                                               // Capacity Bandwidth
        Name = '02-09679',                                                                                                 // BU
        CID_RelD__c = circuitRec.Id
        );
        insert linkRec;         
        
        
        Schedule_TrialLink scheduleObj = new Schedule_TrialLink();
         
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Sched', chron, scheduleObj);
        test.stopTest(); 
    }
}