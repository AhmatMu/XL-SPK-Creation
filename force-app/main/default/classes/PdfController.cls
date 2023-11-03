public class PdfController {
    class Field_Object {
        string fieldName;
        string type;
        string objectName;
    }
    
    public list <selectoption> objects {set;get;}
    public list <selectoption> relatedObjects {set;get;}
    public list <selectoption> fields {set;get;}
    public list <selectoption> sResource {set;get;}
    public list <selectoption> selectionDataList {set;get;}
    public list <selectoption> selectionDataList2 {set;get;}
    public list <selectoption> selectionDataList3 {set;get;}
    public list <selectoption> selectionDataList4 {set;get;}
    public list <selectoption> selectionDataList5 {set;get;}
    public list <selectoption> selectionDataList6 {set;get;}
    public list <selectoption> selectionDataList7 {set;get;}
    public list <selectoption> fieldsLookup {set;get;}
    public String paramValue { get; set; }
    public String selected {set;get;}
    public String selectedrelated {set;get;}
    public String selected2 {set;get;}
    public String selected3 {set;get;}
    public String selected4 {set;get;}
    public String selected5 {set;get;}
    public String selectedfieldrelated {set;get;}
    public String selectedsignature {set;get;}
    public Pdf_Template__c nameTemplate {get;set;}
    public List<String> fldnames { get;set; }
    public Pdf_Template__c listPdfTemplate { get;set; }
    public String objectName { get; set; }
    public String objLookup { get; set; }
    public List<String> strListLookup { get;set; }
    public Set<String> strListObjectRelated { get;set; }
    public Set<String> strListObjectDoc { get;set; }
    public Pdf_Template__c content { get; set; } 
    public String pdf_id { get; set; }
    public String contentPdf { get; set; }
    public String headerPdf { get; set; }
    public String footerPdf { get; set; }
    public String MainObject { get; set; }
    public String display { get; set; }
    public String paternName { get; set; }
    public PageReference URL { get; set; }
    public List<StaticResource> resourceList {get; set;}
    public boolean displayPopup {get; set;}
    public boolean DisplayParam {get; set;}
    public boolean displayCopy {get; set;}
    public boolean displaySelect {get; set;}
    public boolean displaySelect2 {get; set;}
    public boolean displaySelect3 {get; set;}
    public boolean displaySelect4 {get; set;}
    public boolean displaySelectFieldRelated {get; set;}
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();      
    public String myBody {get; set;}
    public String myHeader {get; set;}
    public String myFooter {get; set;}
    public List<String> strObjList { get;set; }
    public List<String> objectRelated { get;set; }
    public string selectedField {get;set;}
    public Map<string, Field_Object> select2Map {get; set;}
    public Map<string, Field_Object> select3Map {get; set;}
    public Map<string, Field_Object> select4Map {get; set;}
    public Map<string, Field_Object> select5Map {get; set;}
    public Map<string, Field_Object> select6Map {get; set;}
    
    public String selected_recId {set;get;}
    
    public PdfController(ApexPages.StandardController controller){
        selected_recId = '';
   //     pdf_id = ApexPages.currentPage().getParameters().get('Id');
        pdf_id = controller.getRecord().Id;
        
        select2Map = new Map<string, Field_Object>();
        select3Map = new Map<string, Field_Object>();
        select4Map = new Map<string, Field_Object>();
        select5Map = new Map<string, Field_Object>();
        select6Map = new Map<string, Field_Object>();
        content = [SELECT Id, Default_Document_Name__c,Tex_Area_1__c,Footer__c,Header__c, Main_Object__c
                   FROM Pdf_Template__c WHERE Id =: pdf_id];
        contentPdf = content.Tex_Area_1__c;
        headerPdf = content.Header__c;
        footerPdf = content.Footer__c;
        MainObject = content.Main_Object__c;
        paternName = content.Default_Document_Name__c;
        resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name LIKE 'signature%'];
       
        fields = new list <selectoption>();
        sResource = new list <selectoption>();
        fieldsLookup = new list <selectoption>();
        
        displayCopy = true;
        displaySelect3 = false;
        selectoption n =new Selectoption('None' ,'-None-');
       
        
        
        fields.add(n);
        fieldsLookup.add(n);
        
        sResource.add(new selectoption('StaticResource','-Signatures-'));
        for( StaticResource signature: resourceList){
            String signatureList = signature.Name;
            sResource.add(new selectoption(signatureList,signatureList));
        }
        
        
        myBody = contentPdf;
        myHeader = headerPdf;
        myFooter = footerPdf;
        nameTemplate = [SELECT Id, Name
                        FROM Pdf_Template__c WHERE Id =: pdf_id];
        
        strListLookup = new List<String>();
        strListObjectRelated = new Set<String>();
        strListObjectDoc = new Set<String>();
        getObjectRelatedDoc();
        /*======== VANDO*/
        //   strObjList = new List<String>();
        
        //    for(Schema.SObjectType targetObj : schemaMap.values()){
        //        strObjList.add(String.Valueof(targetObj));
        //   }
        
        //   system.debug(strListOpp);
        //system.debug('selectedvalue : ' + selectedvalue);
        /*==========*/
    }
    
    public PageReference SaveForm(){
        String valueContent = myBody;
        String objectMain = selected;
        String defaultName = paternName;
        system.debug('CONTENT >>>>'+valueContent);
        system.debug('OBJECT MAIN >>>>'+objectMain);
        edit(valueContent,objectMain,defaultName);
        return null;
    }
    public PageReference SaveHeader(){
        String valueContent = myHeader;
    
        system.debug('CONTENT >>>>'+valueContent);
       
        editHeader(valueContent);
        return null;
        
    }
    public PageReference SaveFooter(){
        String valueContent = myFooter;
        system.debug('CONTENT >>>>'+valueContent);
        editFooter(valueContent);
        return null;
        
    }
    
    public PageReference BackForm(){
        PageReference URL = new PageReference('/'+pdf_id);
        URL.setRedirect(true);
        return URL;
    }
    
    private void edit(String valueContent, String objectMain, String defaultName){
        
        try {
            Pdf_Template__c PdfTemplate=new Pdf_Template__c();
            PdfTemplate.Tex_Area_1__c= valueContent;
            PdfTemplate.Main_Object__c= objectMain;
            listPdfTemplate = [SELECT Id, Default_Document_Name__c,Tex_Area_1__c,Main_Object__c FROM Pdf_Template__c WHERE Id =: pdf_id];
            listPdfTemplate.Default_Document_Name__c = defaultName;
            listPdfTemplate.Tex_Area_1__c = valueContent;
            listPdfTemplate.Main_Object__c = objectMain;
            update ListPdfTemplate;
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        System.debug('UPDATE BERHASIL');
        
    }
    
    private void editHeader(String valueContent){
         try {
        Pdf_Template__c PdfTemplate=new Pdf_Template__c();
        PdfTemplate.Header__c= valueContent;
        listPdfTemplate = [SELECT Id, Header__c,Main_Object__c FROM Pdf_Template__c WHERE Id =: pdf_id];
        listPdfTemplate.Header__c = valueContent;
        update ListPdfTemplate;
         } catch(DmlException e) {
              System.debug('The following exception has occurred: ' + e.getMessage());
         }
         System.debug('UPDATE HEADER BERHASIL');
    }
    
    private void editFooter(String valueContent){
       try {
        Pdf_Template__c PdfTemplate=new Pdf_Template__c();
        PdfTemplate.Header__c= valueContent;
        listPdfTemplate = [SELECT Id, Footer__c,Main_Object__c FROM Pdf_Template__c WHERE Id =: pdf_id];
        listPdfTemplate.Footer__c = valueContent;
        update ListPdfTemplate;
        } catch(DmlException e) {
              System.debug('The following exception has occurred: ' + e.getMessage());
         }
         System.debug('UPDATE HEADER BERHASIL');
    }

    public void closePopup() {
        displayPopup = false;
    }
    
    public void showPopup() {
        displayPopup = true;
    }
    
    public void getdata2(){
        getdata(2);
        if(selected !='None'){
            
            String mainObject = selected;
            getdatarelated(mainObject);
        }
        
    }
    
    public void getdata3(){
        getdata(3);
    }
    
    public void getdata4(){
        getdata(4);
    }
    
    public void getdata5(){
        getdata(5);
    }
    
    public void getdataFieldRelated(){
        getdata(6);
    }
    
    public void getdataChildFieldRelated(){
        getdata(7);
    }
    
    private void getdata(Integer No){
        Map<string, Field_Object> selectMap = new Map<string, Field_Object>();
        String objName ='';
        selectionDataList = New list <selectoption>();
        selectionDataList.clear();
        switch on No {
            when 2 {
                if(selected != 'None'){
                    displaySelect2 = true;
                    selectionDataList2 = New list <selectoption>();
                    objName = selected;
                    String copyTextField = objName;
                    setSelectedField(copyTextField);
                }else{
                    displaySelect2 = false;
                    return;
                }
                
            }	
            when 3 {
                selectionDataList3 = New list <selectoption>();
                Field_Object tmpFieldObject = (Field_Object) select2Map.get(selected2);
                
                String objType = tmpFieldObject.type;
                if(objType == 'REFERENCE' ){
                    objName = tmpFieldObject.objectName;
                    system.debug (' == OBJECT SELECTED2 : ' + objName);
                    displaySelect3 = true;
                    String copyTextField = '%%'+selected.replace('__c', '__r')+'::'+selected2+'%%';
                    copyTextField = copyTextField.replace('__c', '__r').replace('Id.','.');
                    setSelectedField(copyTextField);
                }else{
                    objName = tmpFieldObject.objectName;
                    displaySelect3 = false;
                    displaySelect4 = false;
                    String copyTextField = '%%'+selected+'::'+selected2+'%%';
                    //copyTextField = copyTextField.replace('__c', '__r').replace('Id.','.');
                    copyTextField = copyTextField.replace('Id.','.');
                    setSelectedField(copyTextField);
                    
                    return;  
                }
            }
            when 4 {
                selectionDataList4 = New list <selectoption>();
                Field_Object tmpFieldObject = (Field_Object) select3Map.get(selected3);
                
                objName = tmpFieldObject.objectName;
                
                String objType = tmpFieldObject.type;
                if(objType == 'REFERENCE' ){
                    displaySelect4 = true;
                    String copyTextField = '%%'+selected.replace('__c', '__r')+'::'+selected2.replace('__c', '__r')+'.'+selected3+'%%';
                    copyTextField = copyTextField.replace('__c', '__r').replace('Id.','.');
                    setSelectedField(copyTextField);
                }else{
                    displaySelect4 = false;
                    String copyTextField = '%%'+selected.replace('__c', '__r')+'::'+selected2.replace('__c', '__r')+'.'+selected3+'%%';
                    copyTextField = copyTextField.replace('Id.','.');
                    setSelectedField(copyTextField);
                    return;  
                }
            }
            when 5 {
                selectionDataList5 = New list <selectoption>();
                Field_Object tmpFieldObject = (Field_Object) select4Map.get(selected4);
                objName = tmpFieldObject.objectName;
                system.debug (' == OBJECT SELECTED4 : ' + objName);
                String objType = tmpFieldObject.type;
                if(objType == 'REFERENCE' ){
                    
                    String copyTextField = '%%'+selected+'::'+selected2+'.'+selected3+'.'+selected4+'%%';
                    copyTextField = copyTextField.replace('__c.', '__r.').replace('Id.','.');
                    setSelectedField(copyTextField);
                }else{
                    String copyTextField = '%%'+selected+'::'+selected2+'.'+selected3+'.'+selected4+'%%';
                    copyTextField = copyTextField.replace('__c.', '__r.').replace('Id.','.');
                    setSelectedField(copyTextField);
                    return;
                }
                
            }
            when 6 {
                displaySelectFieldRelated = true;
                selectionDataList6 = New list <selectoption>();
                objName = selectedrelated;
                String copyTextField = objName;
                setSelectedField(copyTextField);
            }
            when 7 {
                selectionDataList7 = New list <selectoption>();
                Field_Object tmpFieldObject = (Field_Object) select6Map.get(selectedfieldrelated);
                
                String objType = tmpFieldObject.type;
                if(objType == 'REFERENCE' ){
                    objName = tmpFieldObject.objectName;
                    system.debug (' == OBJECT SELECTED2 : ' + objName);
                    // displaySelect3 = true;
                    String copyTextField = '%%'+selectedrelated.replace('__c', '__r')+'::'+selectedfieldrelated+'%%';
                    setSelectedField(copyTextField);
                }else{
                    objName = tmpFieldObject.objectName;
                    // displaySelect3 = false;
                    String copyTextField = '%%'+selectedrelated+'::'+selectedfieldrelated+'%%';
                    setSelectedField(copyTextField);
                    
                    return;  
                }
            }
        }
        system.debug ('== displaySelect2 : ' + displaySelect2);
        selectoption n =new Selectoption('None' ,'-None-');
        if(selected !='None'){
            try{
                fldnames = new list<String>();
            Integer i = 0;
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(objName);
            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            
            for (String fieldName: fieldMap.keySet()) {
                Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
                SObjectField fl = fieldMap.get(fieldName);
                String objectLabel ='';
                Field_Object tmpFieldObject = new Field_Object();
                tmpFieldObject.fieldName = string.valueof(fl);
                tmpFieldObject.type = string.valueof(fielddataType);
                if (string.valueof(fielddataType) == 'REFERENCE') {
                    Schema.DescribeFieldResult f = fieldMap.get(fieldName).getDescribe();
                    for(Schema.SObjectType reference : f.getReferenceTo()) {
                        objectName = string.valueof ( reference.getDescribe().getName());
                        objLookup = String.valueof(objectName);
                        tmpFieldObject.objectName =objLookup;
                    }
                    
                    Selectoption p = new selectoption(tmpFieldObject.fieldName, tmpFieldObject.fieldName + ' >'); 
                    selectionDataList.add(p);
                    selectionDataList.sort();
                }else{
                    Selectoption p = new selectoption( tmpFieldObject.fieldName, tmpFieldObject.fieldName );  
                    selectionDataList.add(p);
                    selectionDataList.sort();
                }
                i++;
                
                selectMap.put (tmpFieldObject.fieldName, tmpFieldObject); 
            }
            }catch(ListException le) {
            System.debug('The following exception has occurred: ' + le.getMessage());
        }
            
        }else{
            selectionDataList.add(n); 
        }
        
        switch on No {
            when 2 {
                selectionDataList2 = selectionDataList;
                select2Map = selectMap;
                system.debug (' == select2Map : ' + select2Map);
                
            }
            when 3 {
                selectionDataList3 = selectionDataList;
                select3Map = selectMap;
            }
            when 4 {
                selectionDataList4 = selectionDataList;
                select4Map = selectMap;
            }
            when 5 {
                selectionDataList5 = selectionDataList;
                select5Map = selectMap;
            }
            when 6 {
                selectionDataList6 = selectionDataList;
                select6Map = selectMap;
            }
            when 7 {
                selectionDataList7 = selectionDataList;
                //select6Map = selectMap;
            }
        }
    }
    
    public void setSelectedField (String copyTextField) {
        selectedField = copyTextField ;
        system.debug('>>>> Selected: '+ selectedField );
    }
    
    private void getdatarelated(String mainObject){
        try {  
    	relatedObjects = new list <selectoption>();
        String objectChild = '';
        relatedObjects.clear();
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        
        Schema.SObjectType leadSchema = schemaMap.get(mainObject);
        Schema.DescribeSObjectResult obj = leadSchema.getDescribe(); 
        Integer count = 0;
        
        for ( Schema.ChildRelationship scr : obj.getchildRelationships()){
            String fields = String.valueof(scr.getField());
            strListObjectRelated.add(String.valueof(scr.getChildSObject()));
            count++;
        }
        
        for(String selection: strListObjectRelated){
            Selectoption valueSelect = new selectoption( selection, selection );
            system.debug('>>>> Selected: '+ valueSelect );
            relatedObjects.add(valueSelect);
            relatedObjects.sort();
        }
        } catch(ListException le) {
            System.debug('The following exception has occurred: ' + le.getMessage());
        }
        
    }
    
    private void getObjectRelatedDoc(){
         try { 
        objects = new list <selectoption>();
        objects.clear();
        selectoption n =new Selectoption('None' ,'-None-');
        
        Integer no = 0;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType leadSchema = schemaMap.get('Pdf_Template__c');
        Schema.DescribeSObjectResult objDoc = leadSchema.getDescribe(); 
        for ( Schema.ChildRelationship scrDoc : objDoc.getchildRelationships() ){
    		String fieldsDoc = String.valueof(scrDoc.getField());
            if(fieldsDoc == 'Doc_Template__c'){
            strListObjectDoc.add(String.valueof(scrDoc.getChildSObject()));
            system.debug('');
            system.debug('**** Child SObject         **** ' + scrDoc.getChildSObject());
            system.debug('     Field                 **** ' + scrDoc.getField());
            system.debug('     Relationship Name     **** ' + scrDoc.getRelationshipName());
                no++;
            }
		}
        	//objects.add(n);
          for(String selectionObj: strListObjectDoc){
            Selectoption valueSelectObj = new selectoption( selectionObj, selectionObj );
            system.debug('>>>> Selected: '+ valueSelectObj );
            objects.add(valueSelectObj);
            objects.sort();
        }
         } catch(ListException le) {
            System.debug('The following exception has occurred: ' + le.getMessage());
        }
    }
    
    public void getsignature(){
        String copyTextField = '%%StaticResource::'+selectedsignature+'%%';
        setSelectedField(copyTextField);
    }
    /////// UNTUK SHOW PDF
    public Pagereference goToPreviewPage() {
        PageReference pageRef = Page.VF_Pdf_Preview;
        pageRef.getParameters().put('pdf_id',pdf_id);
        pageRef.getParameters().put('rec_id', selected_recId);
        
        system.debug('selected_recId : ' + selected_recId);
        system.debug('pdf_id : ' + pdf_id);
        return PageRef;
    }
}