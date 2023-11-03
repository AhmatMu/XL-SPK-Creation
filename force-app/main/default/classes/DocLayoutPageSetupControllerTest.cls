@isTest
public class DocLayoutPageSetupControllerTest {
    @isTest static void schenario1(){
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
        DocLayoutPageSetupController pageSetupControllerObj = new DocLayoutPageSetupController(sc);
        
        pageSetupControllerObj.SavePageSetup();
        Test.stopTest();
    }
    
   
}