/**
 * @description       : 
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 11-15-2020
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   11-15-2020   Novando Utoyo Agmawan   Initial Version
**/

@isTest
public class DocLayoutHeaderControllerTest {
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
        DocLayoutHeaderController pageHeaderControllerObj = new DocLayoutHeaderController(sc);
        pageHeaderControllerObj.headerFileNameUpload = 'Gambar2.png';
        pageHeaderControllerObj.UploadHeaderFile();
        pageHeaderControllerObj.beginning();
        pageHeaderControllerObj.next();
        pageHeaderControllerObj.previous();
        pageHeaderControllerObj.last();
        pageHeaderControllerObj.getDisableNext();
        pageHeaderControllerObj.getDisablePrevious();
        pageHeaderControllerObj.getDisableSelectAll();
        pageHeaderControllerObj.getContentDocumentLinks();
        pageHeaderControllerObj.getContentVersions();

        pageHeaderControllerObj.var_cvw[0].isSelected = true;     
        pageHeaderControllerObj.processSelected();
        pageHeaderControllerObj.backProcessSelected();
        pageHeaderControllerObj.getContentVersionLists();
        pageHeaderControllerObj.processDeleteFile();

        Test.stopTest();
    }
}