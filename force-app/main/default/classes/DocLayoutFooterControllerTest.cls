@isTest
public class DocLayoutFooterControllerTest {
    @isTest static void schenario1(){
    
        Pdf_Template__c Pdfobj = new Pdf_Template__c(
            Name = 'MPLS DOCUMENT TEMPLATE1',
            Main_Object__c = 'Opportunity',
            Default_Document_Name__c = 'MPLS DOCUMENT',
            Tex_Area_1__c = 'Hello Word',
            Header__c = ' XL AXIATA',
            Footer__c =' XLAXIATA '
        );
        insert Pdfobj;
        
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = 'Gambar1.png';
        contentVersion.PathOnClient = 'Gambar1.png';
        contentVersion.VersionData = Blob.valueOf('Test Content');
        contentVersion.IsMajorVersion = true;
        Insert contentVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = Pdfobj.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Pdfobj);
        DocLayoutFooterController pageFooterControllerObj = new DocLayoutFooterController(sc);
        pageFooterControllerObj.footerFileNameUpload = 'Gambar2.png';

        pageFooterControllerObj.UploadFooterFile();
        pageFooterControllerObj.beginning();
        pageFooterControllerObj.next();
        pageFooterControllerObj.previous();
        pageFooterControllerObj.last();
        pageFooterControllerObj.getDisableNext();
        pageFooterControllerObj.getDisablePrevious();
        pageFooterControllerObj.getDisableSelectAll();
        pageFooterControllerObj.getContentDocumentLinks();
        pageFooterControllerObj.getContentVersions();

        pageFooterControllerObj.var_cvw[0].isSelected = true;     
        pageFooterControllerObj.processSelected();
        pageFooterControllerObj.backProcessSelected();
        pageFooterControllerObj.getContentVersionLists();
        pageFooterControllerObj.processDeleteFile();

        Test.stopTest();
    }
    
   
}