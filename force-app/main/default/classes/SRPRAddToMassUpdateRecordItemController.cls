/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 16-01-2023
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   16-01-2023   Doddy Prima   Initial Version
**/
public class SRPRAddToMassUpdateRecordItemController {
    ApexPages.StandardSetController setCon;
    //ApexPages.StandardController con;     // this is for detail record purpose 
    
    public List<SR_PR_Notification__c> selectedSRPRList {get; set;}
    public string gselectedSRPRID {get; set;}

    public string massRecordUpdateName {get;set;}
    public ID massRecordUpdateID {get;set;}

    // this is for detail record purpose
    public SRPRAddToMassUpdateRecordItemController(ApexPages.StandardController controller) {  
        SR_PR_Notification__c SRPRList = (SR_PR_Notification__c) controller.getRecord();
    }

    // for multiple records (listview)
    public SRPRAddToMassUpdateRecordItemController(ApexPages.StandardSetController controller) {
        setCon = controller;

        // TODO: need to get the data from data input
        massRecordUpdateID = 'a2r1m000000AL6KAAW';
    }


    public pageReference addItems() {
        system.debug (' === ADD ITEMS ');
        
        List<SR_PR_Notification__c> selectedRecords = (List<SR_PR_Notification__c>) setCon.getSelected();
        selectedSRPRList = selectedRecords;    

        List<Mass_Record_Update__c> mruList = [
            SELECT id 
            FROM Mass_Record_Update__c
            WHERE name = :massRecordUpdateName
        ];

        if ( mruList.size() > 0 ) {
            massRecordUpdateID = mruList[0].id;
        }
            

        List <Mass_Record_Update_Item__c> mruItemList = New List<Mass_Record_Update_Item__c>();
        for (SR_PR_Notification__c SRPRRec : selectedRecords) {
            Mass_Record_Update_Item__c mruItemRec = New Mass_Record_Update_Item__c ();
            mruItemRec.Mass_Record_Update__c = massRecordUpdateID;
            mruItemRec.Selected_Sobject_Record_ID__c = SRPRRec.id;
            mruItemList.add(mruItemRec);
        }
        insert mruItemList;


        
        PageReference listViewPage = new PageReference('/lightning/o/SR_PR_Notification__c/list?filterName=' + setCon.getFilterId() );
        listViewPage.setRedirect(true);

        return listViewPage;
        
    }

    public integer getMySelectedSize() {
        return setCon.getSelected().size();
    }
    public integer getMyRecordsSize() {
        return setCon.getRecords().size();
    }


}