/*
* This class is used to convert the string in the content
* 
*
* @author  Diky Nurosid
* @version 1.00, 30/08/21
* @class    DocBuilderController
* @relation PdfPreviewController
*/


public class DocBuilderController {
    class Field_Object {
        string fieldName;
        string type;
        string objectName;
    }
    public string stringTemplateContent {get;set;}
    public string stringDocContent {get;set;}
    public string stringDocName {get;set;}
    public string stringDocHeader {get;set;}
    public string stringDocImageHeader {get;set;}
    public string stringDocFooter {get;set;}
    public string stringDocImageFooter {get;set;}
    public string stringDocPaternName {get;set;}
    public String stringStyleDocumentSize {get; set;}
    public String stringStyleDocMarginHF {get; set;}
    public String stringStyleDocMarginContent {get; set;}
    public String stringStyleDocMarginContentF {get; set;}
    public String stringStyleDocMarginContentH {get; set;}
    public blob pdfBlobDocContent {get;set;}
    public string templateID {get;set;}
    public string recordID {get;set;}
    Pdf_Template__c pdfTemplateRec {get;set;}
    
    public String TBody { get; set; }
    public String TBodyVal { get; set; }
    public set<String> setRegex { get;set; }
    public set<String> setContent { get;set; }
    public Map<String,list<String>> map_ObjectOfFIeld { get;set; }
    public List<String> map_ObjectOfFIeld_List { get;set; }
    public String str {get; set;}
    String relatedSFIDs;
	String errorMsg;
    
    public DocBuilderController (String templateID, String recordID) {
        try {
            this.templateID = templateID;
            this.recordID = recordID;
            
            pdfTemplateRec = [SELECT Id,Content_Footer_Margin__c, Content_Header_Margin__c, Type_Document__c, Unit_Document__c, Unit_Custom_Document__c,Size_Document__c,Margin_Bottom__c,Margin_Left__c,Margin_Right__c,Margin_Top__c,Width_Custom__c,Height_Custom__c,Tex_Area_1__c,Header_Image__c,Footer_Image__c,Header__c,Footer__c, Main_Object__c, Default_Document_Name__c FROM Pdf_Template__c WHERE Id =: templateID];
            
        } catch(QueryException qe) {
            string notes = 'Error on DocBuilderController. getTemplateBARecord Query.';
            string message =  qe.getmessage() + ' - ' +qe.getStacktraceString() ;
            integer lineNumber = qe.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs;
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg); 
        }
        
        try {
            //    stringTemplateContent = pdfTemplateRec.Tex_Area_1__c;
            stringDocPaternName= pdfTemplateRec.Default_Document_Name__c;
            StringDocHeader = pdfTemplateRec.Header__c;
            stringDocImageHeader = pdfTemplateRec.Header_Image__c;
            StringDocFooter = pdfTemplateRec.Footer__c;
            stringDocImageFooter = pdfTemplateRec.Footer_Image__c;
            
            String size = pdfTemplateRec.Size_Document__c;
            String typeDocument = pdfTemplateRec.Type_Document__c;
            String unitDocument= pdfTemplateRec.Unit_Document__c;
            String unitCustomDoc= pdfTemplateRec.Unit_Custom_Document__c;
            Double widthCustom = pdfTemplateRec.Width_Custom__c;
            Double heightCustom = pdfTemplateRec.Height_Custom__c;
            Double mBottom = pdfTemplateRec.Margin_Bottom__c;
            Double mLeft = pdfTemplateRec.Margin_Left__c;
            Double mTop = pdfTemplateRec.Margin_Top__c;
            Double mRight = pdfTemplateRec.Margin_Right__c;
            Double mTopHeader = pdfTemplateRec.Content_Header_Margin__c;
            Double mBottomFooter = pdfTemplateRec.Content_Footer_Margin__c;
            if(size == 'custom'){
                stringStyleDocumentSize = 'size: '+widthCustom+unitCustomDoc+' '+heightCustom+unitCustomDoc+' '+typeDocument+';';
            }else{
                stringStyleDocumentSize = 'size: '+size+' '+typeDocument+';';
            }
            
            stringStyleDocMarginHF  = 'margin-top: '+mTop+unitDocument+'; margin-bottom: '+mBottom+unitDocument+';margin-left: 0'+unitDocument+';margin-right: 0'+unitDocument+';';
            stringStyleDocMarginContent  = 'margin-top: 0'+unitDocument+'; margin-bottom: 0'+unitDocument+';margin-left: '+mLeft+unitDocument+';margin-right: '+mRight+unitDocument+';';
            stringStyleDocMarginContentH = mTopHeader+'px;';
            stringStyleDocMarginContentF = mBottomFooter+'px;';
            //generateDoc();
            setstringTemplateContent(pdfTemplateRec.Tex_Area_1__c);
        } catch(NullPointerException npe) {
            string notes = 'Error on DocBuilderController. setstringTemplateContent Method Null Data.';
            string message =  npe.getmessage() + ' - ' +npe.getStacktraceString() ;
            integer lineNumber = npe.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs;
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
        }
        
        
        //generatePdfBlob();
    }
    
    public void setstringTemplateContent(String content){
        
        stringTemplateContent = content;
    }
    
    //untuk simpan hasil generate replace FINAL
    public void replacementByType(String type){
        
        switch on type{
            when 'document-content' {
                try {
                    stringDocContent = stringReplacement(stringTemplateContent);
                }catch(NullPointerException npe) {
                    string notes = 'Error on DocBuilderController. replacementByType Method When Document Content.'; string message =  npe.getmessage() + ' - ' +npe.getStacktraceString() ; integer lineNumber = npe.getLineNumber();
                    errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs;
                    apputils.puterror(errorMsg);
                    system.debug ('===== errorMsg : ' + errorMsg);
                   // System.debug('The following exception has occurred: ' + npe.getMessage());
                }
            }
            when 'document-name' {
                try {
                    stringDocName = stringReplacement(stringDocPaternName);
                    system.debug('STRING DOUMENT NAME >>>>>>'+stringDocName);
                } catch(NullPointerException npe) {
                    string notes = 'Error on DocBuilderController. replacementByType Method When Document Name.';string message =  npe.getmessage() + ' - ' +npe.getStacktraceString() ;integer lineNumber = npe.getLineNumber();
                    errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs;
                    apputils.puterror(errorMsg);
                    system.debug ('===== errorMsg : ' + errorMsg);
                }  
            }
        }   
    }
    
    public string stringReplacement(string stringBefore){
        
        stringTemplateContent  = stringBefore;
        system.debug('stringTemplateContent Adalah >>>>> '+stringTemplateContent);
        String MainObject = pdfTemplateRec.Main_Object__c;
        String myRegex1 = '%%(.*?)%%';
        Pattern myPattern = Pattern.compile(myRegex1);
        Matcher myMatchermyPlainText = myPattern.matcher(stringTemplateContent);
        
        setRegex = new set<String>();
        setContent = new set<String>();
        
        while(myMatchermyPlainText.find())
        {
            String leadCode = myMatchermyPlainText.group();
            str = leadCode.replace('%%','');
            setRegex.add(str);
        }
        
        /*================ VANDO ================*/
        system.debug('setRegex = '+ setRegex);
        
        List<String> listRegex = new List<String>();
        listRegex.addAll(setRegex);
        listRegex.sort();
        
        Integer ChangeObject = 1;
        
        map_ObjectOfFIeld = new Map<String,list<String>>();
        
        for(integer i=0;i < listRegex.size() ; i++) {
            if( ChangeObject == 1)
            {
                map_ObjectOfFIeld_List = new list<string>();
            }
            
            ChangeObject = 0;
            
            if(ChangeObject == 0)
            {
                map_ObjectOfFIeld_List.add(listRegex[i].SubStringAfter('::'));
                map_ObjectOfFIeld.put(listRegex[i].SubStringBefore('::'), map_ObjectOfFIeld_List);
            }
            
            if(listRegex.size() == i+1)
            {
                ChangeObject = 1;
            } 
            
            else if(listRegex[i+1].SubStringBefore('::') != listRegex[i].SubStringBefore('::') || i==listRegex.size()-1)
            {
                ChangeObject = 1;
            }
        }
        
        system.debug('map_ObjectOfFIeld : ' + map_ObjectOfFIeld);
        List<Map<String, Object>> listTotal = new List<Map<String, Object>>();
        Map<string, Field_Object> selectMap = new Map<string, Field_Object>();
        String listDataStringVal ='';
        
        for (String key : map_ObjectOfFIeld.keySet()) {
            Integer i = 0;
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(key);
            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            if( key =='StaticResource'){
                String resourceName = String.join(map_ObjectOfFIeld.get(key), ',');
                String param = '%%'+key+'::'+resourceName+'%%';
                String staticResourceUrl = AppUtils.GetResourceURL(resourceName);
                String value = '<img src="'+staticResourceUrl+'"/>';
                stringTemplateContent = stringTemplateContent.replace(param, value);
                system.debug('PARAM value : ' + value);
            }
            if( key == MainObject){
                string queryString = 'SELECT ' + String.join(map_ObjectOfFIeld.get(key), ',')
                    + ' from ' + key +' WHERE Id =\''+recordID+'\'';
                //    + ' limit 1';
                List<SObject> SObjectList = Database.query(queryString);
                system.debug('QueryString : ' + queryString);
                
                for(SObject obj : SObjectList)
                {
                    Map<String,String> mapObj = new Map<String,String>();
                    for (String field : map_ObjectOfFIeld.get(key))
                    {
                        Object value = (Object)AppUtils.getObjectOfRecord(obj, field);
                        if(value == null){
                            value = '';
                        }
                        String param = '%%'+key+'::'+field+'%%';
                        //  system.debug('PARAM : ' + param);
                        stringTemplateContent = stringTemplateContent.replace(param, String.valueOf(value));
                        mapObj.put(field, String.valueOf(value));  
                    }
                    listTotal.add(mapObj);
                    
                }
                System.debug(JSON.serialize(listTotal));
            }else if(key !='StaticResource' && key != MainObject){
                
                String FieldsLookup='';
                Field_Object tmpFieldObject = new Field_Object();
                for (String fieldName: fieldMap.keySet()) {
                    Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
                    SObjectField fl = fieldMap.get(fieldName);
                    
                    tmpFieldObject.fieldName = string.valueof(fl);
                    tmpFieldObject.type = string.valueof(fielddataType);
                    if (string.valueof(fielddataType) == 'REFERENCE') {
                        Schema.DescribeFieldResult f = fieldMap.get(fieldName).getDescribe();
                        for(Schema.SObjectType reference : f.getReferenceTo()) {
                            String objectName = string.valueof ( reference.getDescribe().getName());
                            if(objectName == MainObject){
                                system.debug('OBJECT : ' + objectName);
                                FieldsLookup = tmpFieldObject.fieldName;
                                system.debug('fieldss : ' + FieldsLookup);
                            }
                        }
                    }
                    i++; 
                }
                String queryString = 'SELECT ' + String.join(map_ObjectOfFIeld.get(key), ',')
                    + ' from ' + key +' WHERE '+FieldsLookup+' =\''+recordID+'\'';
                //    + ' limit 1';
                
                List<SObject> SObjectList = Database.query(queryString);
                system.debug('QueryString2 : ' + queryString);
                
                for(SObject obj : SObjectList)
                {
                    Map<String,String> mapObj = new Map<String,String>();
                    
                    TBody = '<tr>';
                    TBodyVal = '<tr>';
                    for (String field : map_ObjectOfFIeld.get(key))
                    {
                        Object value = (Object)AppUtils.getObjectOfRecord(obj, field);
                        if(value == null){
                            value = '';
                        }
                        String param = '%%'+key+'::'+field+'%%';
                        String objectType = AppUtils.getObjectType(value);
                        String hasil = String.valueOf(value);
                        if(objectType == 'integer' || objectType == 'double' || objectType == 'long' || objectType == 'decimal'){
                            Decimal x = Decimal.valueOf(hasil);
                            System.debug(x.format());
                            hasil = x.format();
                        }
                        TBody += '<td colspan="1" rowspan="1">'+param+'</td>';
                        TBodyVal += '<td colspan="1" rowspan="1">'+hasil+'</td>';
                        mapObj.put(field, String.valueOf(value));
                        
                    }
                    TBody += '</tr>';
                    TBodyVal += '</tr>';
                    
                    system.debug('Tbody : ' + TBody);
                    
                    listTotal.add(mapObj);
                    listDataStringVal = listDataStringVal+TBodyVal;
                    
                }
                stringTemplateContent = stringTemplateContent.replace(String.valueOf(TBody), String.valueOf(listDataStringVal));
                System.debug(JSON.serialize(listTotal));
            }
        }
        return stringTemplateContent;
    }
    
    //untuk simpan hasil generate blob final FINAL
    public void generatePdfBlob(){
        PageReference pdf = Page.VF_Pdf_Preview;
        pdf.getParameters().put('pdf_id', templateID);
        pdf.getParameters().put('rec_id', recordID);
        
        if(Test.isRunningTest()) { 
            pdfBlobDocContent = blob.valueOf('Unit.Test');
        } else {
            pdfBlobDocContent = pdf.getContentAsPDF();
        }
    }
    
    public void attachPdfFileToRecord(){
        try{
            Boolean DeleteResult = false;
            List<ContentVersion> contentVersionList = [SELECT ContentDocumentId FROM ContentVersion WHERE Document_Type_Name__c = 'WBA' AND FirstPublishLocationId =: recordID];

            if(contentVersionList !=null && !contentVersionList.isEmpty()){
                set<Id> ContentDocumentIdList = new set<id>();
                    
                for(ContentVersion contentVersionListExtract : contentVersionList){
                    ContentDocumentIdList.add((Id)contentVersionListExtract.ContentDocumentId);
                }

                List<ContentDocument> ContentDocumentList = [select id from ContentDocument where id In:ContentDocumentIdList];

                if(ContentDocumentList!=null && !ContentDocumentList.isEmpty()){
                    Database.DeleteResult[] deleteResults = Database.delete(ContentDocumentList, true);
                    for (Database.DeleteResult deleteResults_Extract : deleteResults) {
                        if (deleteResults_Extract.isSuccess()) {
                            DeleteResult = true;
                        }
                        else {          
                            for(Database.Error error : deleteResults_Extract.getErrors()) {
                                String err_message = 'Error on DocBuilderController.cls - attachPdfFileToRecord ::' + error.getStatusCode() + ': ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields();
                                AppUtils.putError(err_message);
                                System.debug('Error on DocBuilderController.cls - attachPdfFileToRecord::' + error.getStatusCode() + ' : ' + error.getMessage() + ' Fields that affected the error: ' + error.getFields());
                            }
                        }
                    }

                    if(DeleteResult){
                        ContentVersion contentVersion = new ContentVersion();
                        contentVersion.Title = stringDocName + '.pdf';
                        contentVersion.PathOnClient = stringDocName + '.pdf';
                        contentVersion.FirstPublishLocationId = recordID;
                        contentVersion.VersionData = pdfBlobDocContent;
                        contentVersion.IsMajorVersion = true;
                        contentVersion.Document_Type_Name__c = 'WBA';
                        Insert contentVersion;
                    }
                }
            }else{
                ContentVersion contentVersion = new ContentVersion();
                contentVersion.Title = stringDocName + '.pdf';
                contentVersion.PathOnClient = stringDocName + '.pdf';
                contentVersion.FirstPublishLocationId = recordID;
                contentVersion.VersionData = pdfBlobDocContent;
                contentVersion.IsMajorVersion = true;
                contentVersion.Document_Type_Name__c = 'WBA';
                Insert contentVersion; 
            }

               
        } catch(Exception e) {
            string notes = 'Error on DocBuilderController. attachPdfFileToRecord Method.';
            string message =  e.getmessage() + ' - ' +e.getStacktraceString() ;
            integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs;
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);

           // System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
    }
    
    //untuk simpan hasil generate FINAL - visualforce
    public string getStringDocContent(){
        return stringDocContent;
    }
    public string getStringDocName(){
        return stringDocName;
    }
    public string getStringDocImageHeader(){
        return stringDocImageHeader;
    }
    
    public string getStringDocImageFooter(){
        return stringDocImageFooter;
    }
    
    public string getStringDocHeader(){
        return stringDocHeader;
    }
    
    public string getStringDocFooter(){
        return stringDocFooter;
    }
    
    public string getStringTemplateContent() {
        return stringTemplateContent;
    }
    
    public string getStringStyleSize() {
        system.debug('Size : ' + stringStyleDocumentSize);
        return stringStyleDocumentSize;
    }
    public string getStringStyleMarginHF() {
        return stringStyleDocMarginHF;
    }
    public string getStringStyleMarginContent() {
        return stringStyleDocMarginContent;
    }
    public string getStringStyleMarginContentH() {
        return stringStyleDocMarginContentH;
    }
    public string getStringStyleMarginContentF() {
        return stringStyleDocMarginContentF;
    }
    
    public Blob getBlobDocContent(){
        return pdfBlobDocContent;
    }
}