public class ChangePrice_Controller{  
        /**
         * Webkul Software.
         *
         * @category  Webkul
         * @author    Webkul
         * @copyright Copyright (c) 2010-2016 Webkul Software Private Limited (https://webkul.com)
         * @license   https://store.webkul.com/license.html
         */
    ApexPages.StandardSetController setCon;
    ApexPages.StandardController con;
    Change_Price__c selectedCP = new Change_Price__c ();
    
    public string selectListValue {get;set;}
    //public Blob csvFileBody{get;set;}
    
    /*         
    public ChangePrice_Controller() {
    }
    
    public ChangePrice_Controller(ApexPages.StandardSetController controller) {
        setCon = controller;         
    }
    */

    public ChangePrice_Controller(ApexPages.StandardController controller) {
        con = controller;
        
        Change_Price__c tmpCP = (Change_Price__c ) con.getRecord();
        string changePriceID = tmpCP.id;
        
        selectedCP = [select id, customer__c, customer__r.ParentId, customer__r.Organization_Type__c, status__c, name, product__c from Change_Price__c where id =:changePriceID ];
        selectListValue = selectedCP.product__c ;
        
    }
    /* 
    public List<SelectOption> getdynamiclist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('INDIA','INDIA'));
        options.add(new SelectOption('US','US'));
        options.add(new SelectOption('BRAZIL','BRAZIL'));
        return options;
    }
    */
    

    public List<SelectOption> getProductlist() {
        List<SelectOption> options = new List<SelectOption>();
        
        string siteAID =  selectedCP.customer__c;
        string accountHOID = '';
        
        //-- get parent Account (HO)
        if (selectedCP.customer__r.organization_type__c == 'Head Office' ) {
        	accountHOID = selectedCP.customer__c;
        }
        else if (selectedCP.customer__r.organization_type__c == 'Branch' ) {
        	accountHOID = selectedCP.customer__r.ParentId;	
        }
        
        
        /*
        //-- get parent Account (HO)
        List<Account> accList = [select id, ParentId from account where  id =:accountID ];
        
        string parentID='';
        if (accList.size()>0) {
        	parentID = accList[0].ParentId;
        }
        */
        
        AggregateResult[] products = [select service_type__c from link__c 
        		where Site_A_Name__c =:accountHOID 
        			OR Site_A_Name__r.Parentid =:accountHOID
        		group by service_type__c];
        
        /*
        options.add(new SelectOption('INDIA','INDIA'));
        options.add(new SelectOption('US','US'));
        options.add(new SelectOption('BRAZIL','BRAZIL'));
        */
        if (products.size()>0) {
            options.add(new SelectOption( '--Select Product--', '--Select Product--') );
            for (AggregateResult product : products ){
                string productName = (string) product.get('service_type__c');
                options.add(new SelectOption( productName, productName) );
            }
            
            //-- set default value;
            //selectListValue=(string) products[0].get('service_type__c');
            //selectedCP.product__c = selectListValue;
            //update selectedCP;
        }
        
        return options;
    }
    
    public void setProduct () {
        String selectedCPID = selectedCP.id;
        
        if (selectListValue <> selectedCP.product__c ) {
            //-- TODO: Confirmation first !!!! BUAT PAGE CONFIRMATION !!!!
            
            
            //-- DELETE Change Price Link
            List <Change_Price_Link__c> cpls = [select id from Change_Price_Link__c where change_price__c=:selectedCPID ];
            delete cpls ;
            
            //-- DELETE Change Price Link Group
            List <Change_Price_Link_Group__c> cplgs = [select id from Change_Price_Link_group__c where change_price__c=:selectedCPID ];
            delete cplgs ;
        }
    
        
        selectedCP.product__c= selectListValue;
        update selectedCP;
        
        /*
        PageReference p = new PageReference('/' + selectedCPID);
        //PageReference p = new PageReference('https://cs72.lightning.force.com/lightning/r/Change_Price__c/'+ selectedCPID + '/view');

        p.setRedirect(true);
        return p;
        
        */
    }
    
    

 
}