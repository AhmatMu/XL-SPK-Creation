public class SIMCardActivation_Controller{
   
    public List<Opportunity_attachment__c> selectedFailedAttachments {get; set;}
    public string opportunitySFID {get; set;}
    public string opportunityID {get; set;}
        
    ApexPages.StandardSetController setCon;
    ApexPages.StandardController con;
    
    

    public SIMCardActivation_Controller(ApexPages.StandardController controller) {     
         con = Controller;
         Opportunity opp = (Opportunity) con.getRecord();
         string opportunityID = opp.id;
         
         selectedFailedAttachments =
             [select id, title__c from Opportunity_attachment__c where opportunity__c =:opportunityID and status__c='Sent Failed'] ;
         
         system.debug('============== selectedFailedAttachments  : ' + selectedFailedAttachments );
    }

    public SIMCardActivation_Controller(ApexPages.StandardSetController controller) {
       
        setCon = controller;
      
         system.debug('============== setCon : ' + setCon );
         //system.debug('============== OA : ' + OA );         
         system.debug('============== selected : ' + setCon.getselected()  );      
         system.debug('============== getRecords : ' + setCon.getRecords()  );      
         
         List<Opportunity_attachment__c> OAS  = setCon.getRecords();
         
         List<string> ids = new List<string>(); 
         for (Opportunity_attachment__c oa : OAS  ){
             ids.add (oa.id); 
                      }
         selectedFailedAttachments = [select id, title__c, Opportunity__c, Opportunity__r.Opportunity_ID__c   from Opportunity_attachment__c
                 where id in :ids AND status__c='Sent Failed' ];
         
         if (selectedFailedAttachments.size()>0) {
             opportunitySFID = selectedFailedAttachments[0].Opportunity__c ;
             opportunityID = selectedFailedAttachments[0].Opportunity__r.Opportunity_ID__c ;

         }
         
         
    }

    public integer getMySelectedSize() {
        return setCon.getSelected().size();
    }
    public integer getMyRecordsSize() {
        return setCon.getRecords().size();
    }
    
    public pageReference resendConfirm() {
        
        
        REST_SIMCardActivations.UpdateSalesActivationForAttachments(opportunityID); 
        
        system.debug('============== setCon: ' + setCon);
        system.debug('============== opportunityID: ' + opportunityID);
        
        PageReference bapPage = new PageReference('/' + opportunitySFID);
        bapPage.setRedirect(true);
        return bapPage;
    }
    
}