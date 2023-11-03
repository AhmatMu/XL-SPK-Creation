/*
* This class is used for document preview
* 
*
* @author  Diky Nurosid
* @version 1.00, 30/08/21
* @class    PdfPreviewController
* @relation DocBuilderController
*/

public with sharing class PdfPreviewController {
    public String pdf_id { get; set; }
    public String rec_id { get; set; }
    public String ContentPdf { get; set; }
    public String HeaderPdf { get; set; }
    public String HeaderImgPdf { get; set; }
    public String FooterPdf { get; set; }
    public String FooterImgPdf { get; set; }
    public String StyleSize { get; set;}
    public String StyleMarginHF { get; set;}
    public String StyleMarginContent { get; set;}
    public String StyleMarginContentH { get; set;}
    public String StyleMarginContentF { get; set;}
    
    public Boolean RenderHeaderImgPdf {get; set;}
    
    public PdfPreviewController(ApexPages.StandardController controller){
        pdf_id = ApexPages.currentPage().getParameters().get('pdf_id');
        rec_id = ApexPages.currentPage().getParameters().get('rec_id');
        system.debug('pdf_id = ' + pdf_id);
        system.debug('rec_id = ' + rec_id);
        
        DocBuilderController DocBuilderController_Class = new DocBuilderController(pdf_id,rec_id);
        
        DocBuilderController_Class.replacementByType('document-content');
        ContentPdf = DocBuilderController_Class.getStringDocContent();
        //  ContentPdf = DocBuilderController_Class.getStringDocContent();
        HeaderPdf = DocBuilderController_Class.getStringDocHeader();
        HeaderImgPdf = DocBuilderController_Class.getStringDocImageHeader();
        FooterPdf = DocBuilderController_Class.getStringDocFooter();
        FooterImgPdf = DocBuilderController_Class.getStringDocImageFooter();
        StyleSize = DocBuilderController_Class.getStringStyleSize();
        StyleMarginHF = DocBuilderController_Class.getStringStyleMarginHF();
        StyleMarginContent = DocBuilderController_Class.getStringStyleMarginContent();
        StyleMarginContentH = DocBuilderController_Class.getStringStyleMarginContentH();
        StyleMarginContentF = DocBuilderController_Class.getStringStyleMarginContentF();
        
        if(HeaderImgPdf != null || HeaderImgPdf != ''){
            RenderHeaderImgPdf = true;
        }else{
            RenderHeaderImgPdf = false;
        }
        
    } 
}