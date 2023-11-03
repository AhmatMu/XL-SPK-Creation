public class COF_utilsind {
    public string hello {get;set;}
    public string opportunityID {get;set;}   
    public string cofID {get;set;}   
      
    
    public string linkID {get;set;}   
    
    public List<OpportunityLineItem> onetimeOpps {get;set;}
    public List<OpportunityLineItem> onetimeOppsNL {get;set;}
    public List<OpportunityLineItem> onetimeOppsExist {get;set;}

    public List<OpportunityLineItem> recurringOpps {get;set;}
     
    
    public COF_utilsind(ApexPages.StandardController controller) {
         hello='hi world';
         
        
         
         COF__c cof = (COF__c) controller.getRecord();
         
         cofID = cof.id;
         
         
         COF__c selectedCOF = [ select id, name, opportunity__c from cof__c where id =: cofID ];
         opportunityID = selectedCOF.opportunity__c;
         
         
         
         linkID = '-';
         
         Opportunity opp = [ select service_type__C from opportunity where Id =: opportunityID  ];
         string serviceType = opp.service_type__C ;
         
         onetimeOpps = [SELECT Name, unitprice FROM OpportunityLineItem where OpportunityId =: opportunityID and revenue_type__c='One Time'];
         recurringOpps = [SELECT Name, unitprice, capacity__C  FROM OpportunityLineItem where OpportunityId =: opportunityID and revenue_type__c='Recurring'];
         
          
         if (serviceType == 'Newlink') {
             onetimeOppsNL =  onetimeOpps ;
             onetimeOppsExist = null; 
         }
         else {
             onetimeOppsNL =  null;
             onetimeOppsExist= onetimeOpps ;
         }
         
         
         
    }
    
    public pageReference print(){
    
      COF__c COF = [ select id, Ver_No__c, name from cof__c where id =: cofID ];
      if(COF.Ver_No__c >= 1)
        {
           COF.Ver_No__c = COF.Ver_No__c+1;
        }
        else
        {
           COF.Ver_No__c = 1;
        }
        update COF;
        
      PageReference pdf = Page.COF_PDF_IND;
      pdf.getParameters().put('id',cofid);
 
      // create the new attachment
      Attachment attach = new Attachment();
 
      // the contents of the attachment from the pdf
      Blob body;
 
      try {
 
          // returns the output of the page as a PDF
          body = pdf.getContent();
 
          // need to pass unit test -- current bug    
      } catch (VisualforceException e) {
          body = Blob.valueOf('Fail to generate pdf document');
      }
 
      attach.Body = body;
      attach.Name = cof.name+ '_IND_V.' + COF.Ver_No__c+'.PDF';
      attach.IsPrivate = false;
      attach.ParentId = cofid;
      insert attach;

      return pdf;
    }
    public pageReference cancel(){    
      
      return new pageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    } 
}