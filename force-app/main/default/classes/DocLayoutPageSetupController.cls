public class DocLayoutPageSetupController {
public String pdf_id { get; set; }
    public String sizeDocument {get; set;}
    public String typeDocument {get; set;}
    public String unitDocumentCustom {get; set;}
    public double widthCustom {get; set;}
    public double heightCustom {get; set;}
    public String unitMargin {get; set;}
    public double mTop {get; set;}
    public double mBottom {get; set;}
    public double mLeft {get; set;}
    public double mRight {get; set;}
    public double mTopHeader {get; set;}
    public double mBottomFooter {get; set;}
    public Pdf_Template__c listPdfTemplate { get;set; }
    public DocLayoutPageSetupController(ApexPages.StandardController controller){
        pdf_id = controller.getRecord().Id;
        listPdfTemplate = [SELECT Id,Content_Header_Margin__c,Content_Footer_Margin__c,Type_Document__c, Unit_Document__c, Unit_Custom_Document__c,Size_Document__c,Margin_Bottom__c,Margin_Left__c,Margin_Right__c,Margin_Top__c,Width_Custom__c,Height_Custom__c FROM Pdf_Template__c WHERE Id =: pdf_id];
        	
        	sizeDocument = listPdfTemplate.Size_Document__c;
            typeDocument = listPdfTemplate.Type_Document__c;
            unitDocumentCustom = listPdfTemplate.Unit_Custom_Document__c;
            widthCustom = listPdfTemplate.Width_Custom__c;
            heightCustom = listPdfTemplate.Height_Custom__c;
            unitMargin = listPdfTemplate.Unit_Document__c;
            mTop = listPdfTemplate.Margin_Top__c;
            mBottom = listPdfTemplate.Margin_Bottom__c;
            mLeft = listPdfTemplate.Margin_Left__c;
            mRight = listPdfTemplate.Margin_Right__c;
        	mTopHeader = listPdfTemplate.Content_Header_Margin__c;
            mBottomFooter = listPdfTemplate.Content_Footer_Margin__c;
            }
    
    public PageReference SavePageSetup(){
        editPageSetup();
        return null;
    }
    
    private void editPageSetup(){
        Pdf_Template__c PdfTemplate=new Pdf_Template__c();
        
        PdfTemplate.Size_Document__c= sizeDocument;
        PdfTemplate.Type_Document__c= typeDocument;
        PdfTemplate.Unit_Document__c= unitMargin;
        PdfTemplate.Margin_Bottom__c= mBottom;
        PdfTemplate.Margin_Left__c= mLeft;
        PdfTemplate.Margin_Top__c= mTop;
        PdfTemplate.Margin_Right__c= mRight;
        PdfTemplate.Content_Header_Margin__c= mTopHeader;
        PdfTemplate.Content_Footer_Margin__c= mBottomFooter;
        if(sizeDocument == 'custom'){
            PdfTemplate.Unit_Custom_Document__c	= unitDocumentCustom;
            PdfTemplate.Width_Custom__c		= widthCustom;
            PdfTemplate.Height_Custom__c	= heightCustom;
        }
       // listPdfTemplate = [SELECT Id, Type_Document__c, Unit_Document__c, Unit_Custom_Document__c,Size_Document__c,Margin_Bottom__c,Margin_Left__c,Margin_Right__c,Margin_Top__c,Width_Custom__c,Height_Custom__c FROM Pdf_Template__c WHERE Id =: pdf_id];
        listPdfTemplate.Size_Document__c = sizeDocument;
        listPdfTemplate.Type_Document__c = typeDocument;
        listPdfTemplate.Unit_Document__c = unitMargin;
        listPdfTemplate.Margin_Bottom__c = mBottom;
        listPdfTemplate.Margin_Left__c 	= mLeft;
        listPdfTemplate.Margin_Top__c  	= mTop;
        listPdfTemplate.Margin_Right__c	= mRight;
        listPdfTemplate.Content_Header_Margin__c = mTopHeader;
        listPdfTemplate.Content_Footer_Margin__c = mBottomFooter;
        if(sizeDocument == 'custom'){
            listPdfTemplate.Unit_Custom_Document__c = unitDocumentCustom;
            listPdfTemplate.Width_Custom__c = widthCustom;
            listPdfTemplate.Height_Custom__c = heightCustom;
        }
        update listPdfTemplate;
    }
}