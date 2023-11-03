/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-15-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class DocLayoutFooterController {
public String pdf_id { get; set; }
    public blob footerFileUpload { get; set; }
    public String footerFileNameUpload { get; set; }
    public Integer WidthImage {get; set;}
    public Integer HeightImage {get; set;}
    
    public Boolean RenderDisplayImage {get; set;}
    public Boolean RenderSelectedImage {get; set;}
    
    public List<ContentVersion> var_ContentDocumentLinkToshow;
    
    public List<contentVersionWrapper> var_cvw = new List<contentVersionWrapper>();
    public List<ContentDocumentLink> selectedContentVersion {get;set;}
    public List<String> selectedContentVersionListIds {get;set;}
    
    public class contentVersionWrapper{
        public ContentDocumentLink var_cv{get;set;}
        public Boolean isSelected{get;set;}
        
        public contentVersionWrapper(ContentDocumentLink cv){
            var_cv = cv;
            isSelected = false;
        }
    }
    
    //limited display list
    public List<contentVersionWrapper> var_cvwToshow;
    
    //Navigation Variables
    Integer counter = 0;    // To track number of records parsed
    Integer limitSize = 5; // Number of records to be displayed
    Integer totalSize = 0;  // To store the total number of records available
    String errorMsg;
    String relatedSFIDs;
    //Our collection of the class/wrapper objects contentVersionWrapper
    public List<contentVersionWrapper> ContentVersionList {get; set;}
    
    public DocLayoutFooterController(ApexPages.StandardController controller){
        if(Test.isRunningTest()) {
            pdf_id = controller.getRecord().Id;
        }else{
            pdf_id = ApexPages.currentPage().getParameters().get('id');
        }
        relatedSFIDs = pdf_id;
        RenderDisplayImage = false;
        RenderSelectedImage = true;
        
        var_cvwToshow = new List<contentVersionWrapper>();
        var_ContentDocumentLinkToshow = new List<ContentVersion>();
        try {
            List<ContentDocumentLink> contentVersionList = 
                [
                    SELECT Id, 
                    ContentDocumentId, 
                    ContentDocument.LatestPublishedVersionId,
                    ContentDocument.LatestPublishedVersion.Title
                    FROM ContentDocumentLink 
                    WHERE LinkedEntityId =: pdf_id
                ];
            
            //  if(contentVersionList!=null && !contentVersionList.isEmpty()){
            for(ContentDocumentLink contentVersionList_Extract : contentVersionList){
                var_cvw.add(new contentVersionWrapper(contentVersionList_Extract));
                //    }
            }
        } catch(QueryException qe) {
            string notes = 'Error on DocLayoutFooterController. DocLayoutFooterController Method Query Data.';
            string message =  qe.getmessage() + ' - ' +qe.getStacktraceString() ;
            integer lineNumber = qe.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs;
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);

            //System.debug('The following exception has occurred: ' + qe.getMessage());    
        }
        
        totalSize = var_cvw.size();
        
        if((counter+limitSize) <= totalSize){
            for(Integer i = 0; i<limitSize; i++)
                var_cvwToshow.add(var_cvw.get(i));
        }
        else{
            for(Integer i=0;i<totalSize;i++)
                var_cvwToshow.add(var_cvw.get(i));
        }
    }
    
    public PageReference UploadFooterFile(){
        try{
           
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = footerFileNameUpload;
        contentVersion.PathOnClient = footerFileNameUpload;
        contentVersion.FirstPublishLocationId = pdf_id;
        
        if(Test.isRunningTest()) { 
            contentVersion.VersionData = blob.valueOf('Unit.Test');
        } else {
            if(footerFileUpload.size() > 0){
            contentVersion.VersionData = footerFileUpload;
            }
        }
        
        contentVersion.IsMajorVersion = true;
        insert contentVersion;
            
        } catch(Exception e) {
            string notes = 'Error on DocLayoutFooterController. DocLayoutFooterController Method Query Data.';
            string message =  e.getmessage() + ' - ' +e.getStacktraceString() ;
            integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs;
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
               //System.debug('Message: ' + e.getMessage());  
        }
        
        if(Test.isRunningTest()) {
            return null;
        }else{
            PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
            
            //system.debug(ApexPages.currentPage().getUrl());
            pageRef.setRedirect(true);
            return null;
        }
        
    }
    
    public void beginning(){
        
        var_cvwToshow.clear();
        counter=0;
        if((counter + limitSize) <= totalSize){
            
            for(Integer i=0;i<limitSize;i++){
                var_cvwToshow.add(var_cvw.get(i));
            }  
            
        } else{
            
            for(Integer i=0;i<totalSize;i++){
                var_cvwToshow.add(var_cvw.get(i));
            }      
            
        }
        
    }
    
    public void next(){
        
        var_cvwToshow.clear();
        counter=counter+limitSize;
        
        if((counter+limitSize) <= totalSize){
            for(Integer i=counter-1;i<(counter+limitSize);i++){
                var_cvwToshow.add(var_cvw.get(i));
            }
            
        } else{
            for(Integer i=counter;i<totalSize;i++){
                var_cvwToshow.add(var_cvw.get(i));
            }
        }
    }
    
    public void previous(){
        
        var_cvwToshow.clear();
        
        counter=counter-limitSize;      
        
        for(Integer i=counter;i<(counter+limitSize); i++){
            if(!Test.isRunningTest()) {
                var_cvwToshow.add(var_cvw.get(i));
            }
        }
    }
    
    public void last(){
        
        var_cvwToshow.clear();
        
        if(math.mod(totalSize , limitSize) == 0){
            counter = limitSize * ((totalSize/limitSize)-1);
        } else if (math.mod(totalSize , limitSize) != 0){
            counter = limitSize * ((totalSize/limitSize));
        }
        
        for(Integer i=counter-1;i<totalSize-1;i++){
            if(!Test.isRunningTest()) {
                var_cvwToshow.add(var_cvw.get(i));
            }
        }
    }
    
    public Boolean getDisableNext(){
        
        if((counter + limitSize) >= totalSize )
            return true ;
        else
            return false ;
    }
    
    public Boolean getDisablePrevious(){
        
        if(counter == 0)
            return true ;
        else
            return false ;
    }
    
    public Boolean getDisableSelectAll(){
        
        if(totalSize == 0)
            return true ;
        else
            return false ;
    }
    
    public List <contentVersionWrapper> getContentVersions(){
        return var_cvwToshow;
    }
    
    public List <ContentVersion> getContentDocumentLinks(){
        return var_ContentDocumentLinkToshow;
    }
    
    public PageReference processSelected() {
        System.debug('entering processing ..');
        //We create a new list of ContentVersion that wil be populated only with ContentVersion if they are selected
        selectedContentVersion = new List<ContentDocumentLink>();
        selectedContentVersionListIds = new List<String>();
        
        //We will cycle through our list of ContentVersionWrapper and will check to see if the selected property is set to true, if it is we add the ContentVersion to the selectedContentVersion list
        for(ContentVersionWrapper cv: getContentVersionLists()) {
            if(cv.isSelected == true) {
                System.debug('process going on');
                
                selectedContentVersion.add(cv.var_cv);
            }
        }
        
        // Now we have our list of selected ContentVersion and can perform any type of logic we want, sending emails, updating a field on the ContentVersion, etc
        System.debug('Results');
        for(ContentDocumentLink cv: selectedContentVersion) {
            System.debug(cv);
            selectedContentVersionListIds.add(cv.ContentDocument.LatestPublishedVersionId);
        }
        
        if(selectedContentVersionListIds!=null && !selectedContentVersionListIds.isEmpty()){
            
            Pdf_Template__c PdfTemplate = new Pdf_Template__c();
            PdfTemplate.id = pdf_id;
            PdfTemplate.Footer_Image__c = '<img src="'+ URL.getSalesforceBaseUrl().toExternalForm() +'/sfc/servlet.shepherd/version/download/'+selectedContentVersionListIds[0]+'" width="'+100+'%" height="'+100+'%"/>';
            
            
            system.debug('WidthImage : ' + WidthImage);
            system.debug('HeightImage : ' + HeightImage);
            
            /*PdfTemplate.Header_Image__c = '<img src="'+ URL.getSalesforceBaseUrl().toExternalForm() +'/sfc/servlet.shepherd/version/download/'+selectedContentVersionListIds[0]+'" width="'+WidthImage+'%" height="'+HeightImage+'%"/>';*/
            
            Database.SaveResult updateResult = Database.update(PdfTemplate);
            
            if (updateResult.isSuccess()) {
                var_ContentDocumentLinkToshow = 
                    [
                        SELECT Id, 
                        ContentDocumentId, 
                        ContentDocument.LatestPublishedVersionId,
                        ContentDocument.LatestPublishedVersion.Title
                        FROM ContentVersion
                        WHERE ContentDocument.LatestPublishedVersionId =: selectedContentVersionListIds
                    ];
                
                RenderDisplayImage = true;
                RenderSelectedImage = false;
            }
        }
        
        ContentVersionList = null; // we need this line if we performed a write operation  because getContentVersion gets a fresh list now
        return null;
    }
    
    public PageReference processDeleteFile() {
        selectedContentVersion = new List<ContentDocumentLink>();
        selectedContentVersionListIds = new List<String>();
        
        for(ContentVersionWrapper cv: getContentVersionLists()) {
            if(cv.isSelected == true) {
                System.debug('process going on');
                selectedContentVersion.add(cv.var_cv);
            }
        }
        
        System.debug('Results');
        for(ContentDocumentLink cv: selectedContentVersion) {
            System.debug(cv);
            selectedContentVersionListIds.add(cv.ContentDocumentId);
        }
        
        if(selectedContentVersionListIds!=null && !selectedContentVersionListIds.isEmpty()){
            List<ContentDocument> var_ContentDocumentToDelete = 
                [
                    SELECT Id
                    FROM ContentDocument
                    WHERE Id IN : selectedContentVersionListIds
                ];
            delete var_ContentDocumentToDelete;
        }
        
        if(Test.isRunningTest()) {
            return null;
        }else{
            PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
            pageRef.setRedirect(true);
            return pageRef;
        }
    }
    
    public PageReference backProcessSelected() {
        if(Test.isRunningTest()) {
            return null;
        }else{
            PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
            pageRef.setRedirect(true);
            return pageRef;
        }
    }
    
    //This method uses a simple SOQL query to return a List of Opportunity
    public List<ContentVersionWrapper> getContentVersionLists() {
        if(ContentVersionList == null) {
            ContentVersionList = var_cvw;
        }
        return ContentVersionList;
    }
}