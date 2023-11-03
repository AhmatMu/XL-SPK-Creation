public class UpdatePRController{
   
    //public List<Opportunity> OppList {get; set;}
    public string opportunitySFID {get; set;}
    public string opportunityID {get; set;}
    public boolean isValid {get; set;}
    public string title {get; set;}    
        
    ApexPages.StandardSetController setCon;
    ApexPages.StandardController con;
    
    

    public UpdatePRController(ApexPages.StandardController controller) {  
        system.debug('enter');   
        con = Controller;
        Opportunity tempOpp = (Opportunity) con.getRecord();
        String tmpOpportunityID = tempOpp.id;
         
        Opportunity Opp = [select id, SR__c, PR__c from opportunity where id=:tmpOpportunityID]; 
        Profile Prfl = [select name from Profile where id = :UserInfo.getProfileId()];
        
        opportunityID = opp.id;
        opportunitySFID=opp.id;
        
        if((Prfl.name=='Sales'||Prfl.name=='System Administrator')){
            if(Opp.SR__c==null||Opp.SR__c=='')
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'SR is Empty');
                ApexPages.addMessage(myMsg); 
            }
             if(Opp.PR__c==null||Opp.PR__c=='')
            {
                ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,'PR is Empty');
                ApexPages.addMessage(myMsg2); 
            }
            if ((Opp.SR__c==null||Opp.SR__c=='') || (Opp.PR__c==null||Opp.PR__c=='') ) {
                isValid = false;
                title  = 'The update PR process cannot be continue.';
                
            } else { 
                isValid = true;
                title ='Confirmation. Are you sure to Update PR?';    
            }
        } else {
            ApexPages.Message myMsg3 = new ApexPages.Message(ApexPages.Severity.ERROR,'Your Profile Cannot Access This Function');
            ApexPages.addMessage(myMsg3); isValid = false; title  = 'You are not allowed to do this, please contact your Administrator';
        }

        
        
}
            
    /*  public UpdatePRController(ApexPages.StandardSetController controller) {
       
        setCon = controller;
        OppList=setcon.getrecords();
         if (OppList.size()>0) {
             opportunitySFID = OppList[0].ID ;
             opportunityID = OppList[0].ID ;
        
               }
      }*/

   
    
    public pageReference resendConfirm() {
        
        
        UpdatePRInformation.UpdatePRInformationUpdate(opportunityID); 
        
		/* edit by doddy January 22, 2019 - Move to event stage Waiting for Contract 
		        
        Opportunity Opp = [select id,Note__c,StageName, Account_Site_A__c,Link_Related__c,BP_Payer__c,BP_VAT__c,Service_Type__c,auto_renewal__c,recordtype.Name,Account_Site_B__c,Contract_Periode__c from opportunity where id=:OpportunityID]; 
       try{
        Contract_Ticket__c CT=[SELECT id FROM Contract_Ticket__c WHERE Opportunity__c=:OpportunityID];
        list<OpportunityLineItem> listOLI=[SELECT id,Quantity,product2id,billing_type__c,contract_start_date__c,contract_end_date__c,UnitPrice FROM OpportunityLineItem WHERE OpportunityID=:OpportunityID];
      //  list<Contract_Ticket_Item__c> listCTI=[SELECT id FROM Contract_ticket_item__c WHERE Contract_Ticket__c=:CT.id];
        list<Contract> listCI=[SELECT id,Quantity__c,Link__c,Account_BP_Payer__c,Account_Site_A_BP_Site__c,Account_BP_VAT__c,Product__c,Billing_Type__c,Start_Date__c,End_Date__c,price__c,auto_renewal__c,StartDate,EndDate FROM Contract WHERE Opportunity__c=:OpportunityID];
        for(Integer i=0;i<listOLI.size();i++)
        {
            for(Integer j=0;j<listCI.size();j++)
            {
                    listCI[j].Account_Site_A_BP_Site__c=Opp.Account_Site_A__c;
                    if(Opp.RecordType.Name.Contains('Leased Line'))
                    listCI[j].Account_Site_B_BP_Site__c=Opp.Account_Site_B__c;
                    listCI[j].Account_BP_Payer__c=Opp.BP_Payer__c;
                    listCI[j].Account_BP_VAT__c=Opp.BP_VAT__c;
                if(OPP.Link_Related__c!=listCI[j].Link__c)
                    listCI[j].Link__c=Opp.Link_Related__c;
                if(listOLI[i].Product2id==listCI[j].Product__c || test.isrunningtest())
                {
                    listCI[j].billing_type__c =listOLI[i].billing_type__c;
                    listCI[j].start_date__c=listOLI[i].Contract_start_date__C;
                    listCI[j].end_date__c=listOLI[i].Contract_end_date__c;
                    listCI[j].Quantity__c=listOLI[i].Quantity;
                    listCI[j].Price__c=listOLI[i].UnitPrice;
                     listCI[j].startdate=listOLI[i].Contract_start_date__C;
                   listCI[j].contractterm=Integer.valueof(Opp.Contract_Periode__c);
                }
            }
        }
          Opp.StageName='Waiting for Contract';
        Opp.Note__c='Send Email To Contract Manager';
        update Opp;
        update listCI;
      
       }
       catch(exception e)
       {
        
       }
       */
       
        PageReference p = new PageReference('/' + opportunitySFID);
        //PageReference p = new PageReference('https://cs72.lightning.force.com/lightning/r/Change_Price__c/'+ selectedCPID + '/view');

        p.setRedirect(true);
        return p;
    }
    
}