public with sharing class DocPreviewController {
    public Pdf_Template__c doc {get; set;}
    public Id rec_id {get;set;}
    public Id pdf_id {get;set;}
    public String sObjName {get;set;}
    public Boolean isshow {get;set;}
    public Boolean isshowemail {get;set;}
    public DocPreviewController() {
        isshow=true;
        isshowemail=true;
        rec_id = Apexpages.currentPage().getParameters().get('id');
        sObjName = rec_id.getSObjectType().getDescribe().getName();
        if(sObjName != 'Opportunity'){
            isshowemail=false;
        } 
        String queryDocument = 'SELECT Id, Doc_Template__c FROM '+sObjName+' WHERE Id = \''+rec_id+'\'';
       
            List<SObject> DocumentList = Database.query(queryDocument);
            system.debug('Document LIST >>>> '+ DocumentList);
            
            for(SObject Obj :DocumentList){
                pdf_id = String.valueOf(Obj.get('Doc_Template__c'));
            }
            
            try {
                doc = [SELECT Id, Main_Object__c FROM Pdf_Template__c WHERE Id =: pdf_id];
                String MainObject = doc.Main_Object__c;
                if(sObjName != MainObject){
                    isshow=false;
                    isshowemail=false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Document Template Is Not Applicable With This Record'));
                }
                
            }catch(QueryException qe) {   
                isshow=false;
                isshowemail=false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Document Template is still empty in This Record'));
                System.debug('The following exception has occurred: ' + qe.getMessage()); 
            } 
        
        system.debug('RECORD ID >>>> '+ rec_id);
        system.debug('DOC ID >>>> '+ pdf_id);
        
    }
    
    public void generateDoc() {
        Id rec_id = Apexpages.currentPage().getParameters().get('id');
        sObjName = rec_id.getSObjectType().getDescribe().getName();
        String queryDocument = 'SELECT Id, Doc_Template__c FROM '+sObjName+' WHERE Id = \''+rec_id+'\'';
        List<SObject> DocumentList = Database.query(queryDocument);
        system.debug('Document LIST >>>> '+ DocumentList);
        
        for(SObject Obj :DocumentList){
            pdf_id = String.valueOf(Obj.get('Doc_Template__c'));
        }
        DocBuilderController DocBuilderController_Class = new DocBuilderController(pdf_id,rec_id);
        DocBuilderController_Class.replacementByType('document-name'); // fungsi membuat nama file
        DocBuilderController_Class.generatePdfBlob(); // fungsi membuat blob
        DocBuilderController_Class.attachPdfFileToRecord(); // fungsi attach file
    }
    
    
    
}