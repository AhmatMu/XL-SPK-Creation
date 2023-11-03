@isTest
public class PdfControllerTest {
  /*  @isTest static void schenario1(){
        //TEST CONSTRUCT
        //
        Test.startTest();
        Pdf_Template__c sobj = new Pdf_Template__c(
            Name = 'MPLS DOCUMENT TEMPLATE1',
            Main_Object__c = 'Opportunity',
            Default_Document_Name__c = 'MPLS DOCUMENT',
            Tex_Area_1__c = 'Hello Word',  // Tex Area 1
            Header__c = ' XL AXIATA',
            Footer__c = ' XL AXIATA '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      // Footer
        );
        insert sobj;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sobj);
        PdfController pdfControllerObj = new PdfController(sc);
        
        pdfControllerObj.selected = 'Opportunity';
        pdfControllerObj.selected2 = 'PR_Rel__c';
        pdfControllerObj.selected3 = 'Circuit__c';
        pdfControllerObj.selected4 = 'CID__c';
        pdfControllerObj.selectedrelated = 'OpportunityLineItem';
        pdfControllerObj.selectedfieldrelated = 'Quantity';
        pdfControllerObj.selectedsignature='signaturesigit';
        pdfControllerObj.getdata2();
        pdfControllerObj.getdata3();
        pdfControllerObj.getdata4();
        pdfControllerObj.getdata5();
        pdfControllerObj.getdataFieldRelated();
        pdfControllerObj.getdataChildFieldRelated();
        pdfControllerObj.getsignature();
        pdfControllerObj.SaveForm();
        pdfControllerObj.SaveHeader();
        pdfControllerObj.SaveFooter();
        pdfControllerObj.BackForm();
        pdfControllerObj.goToPreviewPage();
        Test.stopTest();
    }*/
    
    @isTest static void schenario2(){
        //TEST CONSTRUCT
        //
        Test.startTest();
        Pdf_Template__c sobj = new Pdf_Template__c(
            Name = 'EDA DOCUMENT TEMPLATE1',
            Main_Object__c = 'EDA__c',
            Default_Document_Name__c = 'EDA DOCUMENT',
            Tex_Area_1__c = 'Hello Word',  // Tex Area 1
            Header__c = ' XL AXIATA',
            Footer__c = ' XL AXIATA '                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      // Footer
        );
        insert sobj;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sobj);
        PdfController pdfControllerObj = new PdfController(sc);
        
        pdfControllerObj.selected = 'EDA__c';
        pdfControllerObj.selected2 = 'BAP__c';
        pdfControllerObj.selected3 = 'BA_Extend_REL__c';
        pdfControllerObj.selected4 = 'Complete_Status__c';
        pdfControllerObj.selectedrelated = 'EDA_Detail__c';
        pdfControllerObj.selectedfieldrelated = 'Name';
        pdfControllerObj.selectedsignature='signaturesigit';
        pdfControllerObj.getdata2();
        pdfControllerObj.getdata3();
        pdfControllerObj.getdata4();
        pdfControllerObj.getdata5();
        pdfControllerObj.getdataFieldRelated();
        pdfControllerObj.getdataChildFieldRelated();
        pdfControllerObj.getsignature();
        pdfControllerObj.SaveForm();
        pdfControllerObj.SaveHeader();
        pdfControllerObj.SaveFooter();
        pdfControllerObj.BackForm();
        pdfControllerObj.goToPreviewPage();
        Test.stopTest();
    }
    
    //TEST Method Edit
    //
    
}