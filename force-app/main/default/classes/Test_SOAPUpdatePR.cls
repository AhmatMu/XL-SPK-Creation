@isTest (seealldata=true)
public class Test_SOAPUpdatePR {
  
       
       static testMethod void testsoapupdatePR()
       {
            test.starttest();
            
            Opportunity OP=[SELECT opportunity_ID__c FROM Opportunity WHERE StageName='Implementation' AND Service_Type__c='NewLink' AND Account.BillingStreet!=null ORDER BY Createddate DESC LIMIT 1];
            SOAPUpdatePR.updatePR(Op.Opportunity_ID__c,'1','2','','COMP','','','20180522','012');
            SOAPUpdatePR.updatePR(Op.Opportunity_ID__c,'1','2','COM','','','','20180522','012');
     //       SOAPUpdatePR.updatePR(Op.Opportunity_ID__c,'1','2','COM','','','','20190101','012');
            SOAPUpdatePR.updatePR(Op.Opportunity_ID__c,'1','2','WBA','','','','20190101','012');
            
            test.stoptest();
       }
      
       
       static testMethod void testsoapupdatePR2()
       {
         /*   test.starttest();
            
            Opportunity OP=[SELECT opportunity_ID__c FROM Opportunity WHERE StageName='Implementation' 
                and periode_uom__c = 'Year' ORDER BY Createddate DESC LIMIT 1];
            SOAPUpdatePR.updatePR(Op.Opportunity_ID__c,'1','2','WBA','','','','20180522','012');
            
            test.stoptest();*/
       }

       static testMethod void testsoapupdatePR3()
       {
            test.starttest();
            Opportunity OP=[SELECT opportunity_ID__c FROM Opportunity WHERE StageName='Implementation' 
                and periode_uom__c = 'Month' AND Account.BillingStreet!=null ORDER BY Createddate DESC LIMIT 1];
            SOAPUpdatePR.updatePR(Op.Opportunity_ID__c,'1','2','WBA','','','','20180522','012');
            test.stoptest();
       }
       
       static testMethod void testsoapupdatePR4()
       {
            test.starttest();
            Opportunity OP=[SELECT opportunity_ID__c FROM Opportunity WHERE StageName='Implementation' ORDER BY Createddate DESC
                LIMIT 1];
            SOAPUpdatePR.updatePR(Op.Opportunity_ID__c,'1','2','CNCL','','','','20180522','012');
            test.stoptest();
       }

       static testMethod void testsoapupdatePR5()
       {
            test.starttest();
            Opportunity OP=[SELECT opportunity_ID__c FROM Opportunity WHERE StageName<>'Implementation' 
                and StageName<> 'Waiting for BA'  and stageName = 'Closed Won' LIMIT 1];
            SOAPUpdatePR.updatePR(Op.Opportunity_ID__c,'1','2','CNCL','','','','20180522','012');
            test.stoptest();
       }
              
                     
       
       static testMethod void testsoapupdatePRCatchError()
       {
            test.starttest();
            
            Opportunity OP=[SELECT opportunity_ID__c FROM Opportunity WHERE StageName='Implementation'  AND Account.BillingStreet!=null ORDER BY Createddate DESC LIMIT 1];
            SOAPUpdatePR.updatePR(Op.Opportunity_ID__c,'1','2','COM','','','','','012');

            test.stoptest();
       }    
       
}