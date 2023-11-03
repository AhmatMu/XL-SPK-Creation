public class BAP_Controller{
    // just for test
    // by doddy
    
    ApexPages.StandardSetController setCon;
    ApexPages.StandardController con;
    
    public List<BAP__c> selectedBAPs {get; set;}
    public string gselectedBAPID {get; set;}


    public BAP_Controller(ApexPages.StandardController controller) {     
         BAP__c bap = (BAP__c) controller.getRecord();
         con = Controller;
         List<BAP__c> selectedBAP = [select id, Name, customer__C, Link__c, Approval_IOM__c, Sales_Manager__c, GM_Sales__c, Senior_GM_Operation__c 
            from BAP__c where id = :bap.id];
         selectedBAPs = selectedBAP ;
    }

    public BAP_Controller(ApexPages.StandardSetController controller) {
        setCon = controller;
    }

    public integer getMySelectedSize() {
        return setCon.getSelected().size();
    }
    public integer getMyRecordsSize() {
        return setCon.getRecords().size();
    }
    
    public pageReference singleApprove() {
        String selectedBAPID = (String) Con.getRecord().id;
        List<BAP__c> selectedBAP = [select id, Name, Link__c, Approval_IOM__c, Sales_Manager__c, GM_Sales__c, Senior_GM_Operation__c 
            from BAP__c where id = :selectedBAPID];
        //selectedBAPs = selectedBAP ;
        approve (selectedBAP  );
        
        PageReference bapPage = new PageReference('/a09?fcf=00B5D000000xE6Z');
        bapPage.setRedirect(true);
        return bapPage;
    }
    
    public pageReference selectedApprove() {
        system.debug (' =========== APPROVAL CONFIRM ');
        
        //BAP__c[] selectedBAP = setCon.getSelected();
        List<BAP__c> selectedBAPID = (List<BAP__c>) setCon.getSelected();
        List<BAP__c> selectedBAP = [select id, Name, Approval_IOM__c, Sales_Manager__c, GM_Sales__c, Senior_GM_Operation__c 
            from BAP__c where id IN :selectedBAPID];
            
        approve (selectedBAP );
        
        PageReference bapPage = new PageReference('/a09?fcf=00B5D000000xE6Z');
        bapPage.setRedirect(true);
        return bapPage;
        
    }
    public pageReference reset () {
        String gselectedBAPID = (String) Con.getRecord().id;
        List<BAP__c> selectedBAP = [select id, CID__c, Name, Link__c, link__r.name, customer__C, 
            links_info__c, address__c, 
            Approval_IOM__c, Sales_Manager__c, GM_Sales__c, Senior_GM_Operation__c 
            from BAP__c where id = :gselectedBAPID];

        BAP__c[] tmpBAPList = new List<BAP__c>();
        BAP__c tmpBAP = new BAP__c();
        String linksInfo = '';
        
        for (BAP__c bap: selectedBAP ) {

            //-- SET DEFAULT --

            // set LINKS                
            string cid=bap.CID__c;
            system.debug('=============== cid : ' + cid);
            system.debug('=============== cid2 : ' + bap.link__C);
            system.debug('=============== cid3 : ' + bap.link__r.name);
            system.debug('=============== cid3 : ' + bap.CID__c);
            
            
            List<Link__c> links = [SELECT link_id__c from link__c where name=:cid];
            system.debug('=============== links : ' + links);
            
            linksInfo=''; 
            integer no =1;
            for (Link__c link : links){
                //linksInfo = linksInfo + '&nbsp;' + '&nbsp;' + no + '. ' + link.link_id__c + '<br />'; 
                linksInfo = linksInfo + no + '. ' + link.link_id__c + '\r\n'; 
                no = no+1;
            }
            bap.links_info__c = linksInfo;
            system.debug('=============== linksInfo : ' + linksInfo);
            
            // set PIC Name, Phone, email, and position
            string accID = bap.Customer__c;
            
            List <AccountContactRelation> accContacts =  [SELECT AccountId, Contact.name, Contact.phone, Contact.email,Contact.Title, Id, Roles FROM AccountContactRelation where AccountId =:accID ] ;
            system.debug('=============== accContacts : ' + accContacts );
            
            string picNames='' ;
            string picPhones='' ;
            string picEmails='' ;
            string picPositions='' ;
            
            if (accContacts .size() >0 ) {
                for (AccountContactRelation accContact : accContacts ) {
                    if (accContact.Contact.name<> null) picNames = picNames  + accContact.Contact.name  + ',';
                    if (accContact.Contact.phone <> null) picPhones= picPhones+ accContact.Contact.phone + ',';
                    if (accContact.Contact.email<> null) picEmails= picEmails+ accContact.Contact.email  + ',';
                    if (accContact.Contact.Title <> null) picPositions= picPositions+ accContact.Contact.Title + ', ';
                }
            }
            integer l = picEmails.length() -1 ;
            if (picEmails <>'' ) { picEmails = picEmails.removeEnd(',') ; }
            
            // -- set default --
            bap.pic_name__c = picNames ; 
            bap.pic_phone__c = picPhones ; 
            bap.pic_email__c = picEmails; 
            bap.pic_position__c = picPositions; 
            bap.address2__c = bap.address__c ;

            tmpBAP = bap;
            tmpBAPList.add (tmpBAP);
        }
        if(!test.isRunningTest())
        {
        update tmpBAPList;
        }
        PageReference bapPage = new PageReference('/' + tmpBAP.id );
//        PageReference bapPage = new PageReference('https://cs72.lightning.force.com/lightning/r/BAP__c/a095D000000tlw3QAA/view');


        bapPage.setRedirect(true);
        return bapPage;

    }

    public void approve (List<BAP__c> selectedBAP ) {

        /*
        List<BAP__c> selectedBAP = [select id, Name, Approval_IOM__c, Sales_Manager__c, GM_Sales__c, Senior_GM_Operation__c 
            from BAP__c where id IN :selectedBAPID];
        */

        BAP__c[] tmpBAPList = new List<BAP__c>();
        BAP__c tmpBAP = new BAP__c();
        
        for (BAP__c bap: selectedBAP ) {
            system.debug (' =========== selected : ' + bap.name);
            
            tmpBAP = new BAP__c();
            tmpBAP.id = bap.id;
            
            //tmpBAP.Approval_status__c = 'Approved';
            string userLoginID = UserInfo.getUserId() ;
            system.debug ('============ userLoginID ' + userLoginID);
            system.debug ('============ tmpBAP.Sales_Manager__c ' + bap.Sales_Manager__c);
            system.debug ('============ tmpBAP.GM_Sales__c ' + bap.GM_Sales__c);
            system.debug ('============ tmpBAP.Senior_GM_Operation__c ' + bap.Senior_GM_Operation__c);
            
            if  (userLoginID == bap.Sales_Manager__c) {
                tmpBAP.Approval_Status_by_Sales_Manager__c = 'Approved' ;
                //tmpBAP.Approval_Date_by_Sales_Manager__c = System.now();
                //if (bap.Approval_IOM__c=='2' || bap.Approval_IOM__c=='3'  )
                //    tmpBAP.Approval_status__C = 'Need GM Sales Approval';
                //else tmpBAP.Approval_status__C = 'Approved';
            }
            if  (userLoginID == bap.GM_Sales__c) {
                tmpBAP.Approval_Status_by_GM_Sales__c = 'Approved' ;
                //tmpBAP.Approval_Date_by_GM_Sales__c = System.now();
                //if (bap.Approval_IOM__c=='3'  )
                //    tmpBAP.Approval_status__C = 'Need Senior GM Operation Approval';
                //else tmpBAP.Approval_status__C = 'Approved';
            }
            if  (userLoginID == bap.Senior_GM_Operation__c) {
                tmpBAP.Approval_Status_by_Senior_GM_Operation__c = 'Approved' ;
                //tmpBAP.Approval_Date_by_Senior_GM_Operation__c = System.now();
                //tmpBAP.Approval_status__C = 'Approved';
            }
            
            tmpBAPList.add(tmpBAP); 

        }
        
        update tmpBAPList;    
    
    
    }
    
}