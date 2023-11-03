/*
* This class to add the function of the document template
* Example : opportunity to display documents based on product code
*
* @author  Diky Nurosid
* @version 1.00, 30/08/21
* @class   DocTemplateController
*/
public with sharing class DocTemplateController {
    
    public static void setDocumentTemplateinOpportunity(Id recordID){
        String relatedSFIDs;
        relatedSFIDs = recordID;
	    String errorMsg;
        Opportunity Opp = new Opportunity();
        Opp.Id = recordID;
        Id docID;
        //  if(OliList.size() > 0){
        try {
            List<OpportunityLineItem> OliList = [SELECT OpportunityId, Product2Id, Product2.Product_Code2__c from OpportunityLineItem WHERE OpportunityId =: recordID AND Product2.Product_Code2__c != null];
            
            String Product_Code = string.valueof(OliList[0].Product2.Product_Code2__c);
            Opp = [SELECT Service_Type__c FROM Opportunity WHERE Id = :recordID];
            if(Product_Code == null){
                Product_Code ='';
            }
            //  String Service_Type = Opp.getSobject('Opportunity').get('Service_Type__c');
            system.debug('Product_Code >>>> '+ Product_Code);
            system.debug('Service Type >>>> '+ Opp.Service_Type__c );
            List <Template_Mapping__c>  mapping = new list<Template_Mapping__c>();
            List <Template_Mapping__c>  mapping2 = new list<Template_Mapping__c>();
            mapping = [SELECT Id, Name, Type__c, Product_Code__c, Service_Type__c, Template__c FROM Template_Mapping__c WHERE Type__c = 'BA' AND Product_Code__c = :Product_Code
                       AND Service_Type__c = : Opp.Service_Type__c LIMIT 1];
            
            mapping2 = [SELECT Id, Name, Type__c, Product_Code__c, Service_Type__c, Template__c FROM Template_Mapping__c WHERE Type__c = 'BA' AND Product_Code__c = :Product_Code AND Service_Type__c = : NULL  LIMIT 1];

            if(mapping.size() > 0){
                docID = mapping[0].Template__c;
                system.debug('Product_Code >>>> '+ Product_Code);
                system.debug('Name >>>> '+ mapping[0].Name);
            }else if(mapping2.size() > 0){
                docID = mapping2[0].Template__c;
                system.debug('Product_Code2 >>>> '+ Product_Code);
                system.debug('Name2 >>>> '+ mapping2[0].Name);
            }

            Opp.Doc_Template__c = docID;
            update Opp;
        } catch(Exception e) {
            string notes = 'Error on DocTemplateController.setDocumentTemplateinOpportunity method.';
            string message =  e.getmessage() + ' - ' +e.getStacktraceString() ;
            integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs;
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
    }
    
    //AUTO GENERATE DOKUMEN DARI TRIGGER OPPORTUNITY KETIKA PINDAH STAGE KE WBA
    @Future(callout=true)
    public static void generateDocument(Id recordID) {
        String relatedSFIDs;
        relatedSFIDs = recordID;
	    String errorMsg;
        Id pdf_id;
        Id recID = recordID;
        try {
            String sObjName = recID.getSObjectType().getDescribe().getName();
            String queryDocument = 'SELECT Id, Doc_Template__c FROM '+sObjName+' WHERE Id = \''+recID+'\'';
            List<SObject> DocumentList = Database.query(queryDocument);
            
            for(SObject Obj :DocumentList){
                pdf_id = String.valueOf(Obj.get('Doc_Template__c'));
            }
            DocBuilderController DocBuilderController_Class = new DocBuilderController(pdf_id,recID);
            DocBuilderController_Class.replacementByType('document-name'); // fungsi membuat nama file
            DocBuilderController_Class.generatePdfBlob(); // fungsi membuat blob
            DocBuilderController_Class.attachPdfFileToRecord(); // fungsi attach file
        } catch(Exception e) {
            string notes = 'Error on DocTemplateController.generateDocument method.';
            string message =  e.getmessage() + ' - ' +e.getStacktraceString() ;
            integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs;
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
        //  return pdf;
    }
    public static Boolean CheckMappingDocument(Id recordID, String OppServisType){
        String relatedSFIDs;
        relatedSFIDs = recordID;
	    String errorMsg;
        Boolean templateIsAvailable = false;
        try {
        List<OpportunityLineItem> OliList = [SELECT OpportunityId, Product2Id, Product2.Product_Code2__c from OpportunityLineItem WHERE OpportunityId =: recordID AND Product2.Product_Code2__c != null];
            
        String Product_Code = string.valueof(OliList[0].Product2.Product_Code2__c);
        if(Product_Code == null){
            Product_Code ='';
        }
        List <Template_Mapping__c>  mapping = new list<Template_Mapping__c>();
        mapping = [SELECT Id, Name, Type__c, Product_Code__c, Service_Type__c, Template__c FROM Template_Mapping__c WHERE Type__c = 'BA' AND Product_Code__c = :Product_Code LIMIT 1];
       
        if(mapping.size() > 0){
            templateIsAvailable = true;
        }
        
        System.debug('DEBUG: ' + templateIsAvailable);
        } catch (Exception e) {
            string notes = 'Error on DocTemplateController.generateDocument method.';
            string message =  e.getmessage() + ' - ' +e.getStacktraceString() ;
            integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs;
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        
        }
        return templateIsAvailable;
        
    }
}