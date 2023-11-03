@IsTest
public class TA_AT_SetSelectedSearchItemsView_Test {

    @TestSetup
    static void makeData(){
        Mass_Record_Update_List_View__c Selected_Search_Items_View = new Mass_Record_Update_List_View__c();
        Selected_Search_Items_View.Selected_List_View__c = 'Id;OwnerId;IsDeleted;RecordTypeId;CreatedDate';
        Selected_Search_Items_View.Name='Selected_Search_Items_View';

        insert Selected_Search_Items_View;

        Mass_Record_Update_List_View__c Selected_Search_Record_Items_View = new Mass_Record_Update_List_View__c();
        Selected_Search_Record_Items_View.Selected_List_View__c = 'Id;Capacity_After__c;Capacity_Before__c;CreatedDate;Mass_Update_Status__c';
        Selected_Search_Record_Items_View.Name='Selected_Search_Record_Items_View';

        insert Selected_Search_Record_Items_View;
    }
    
    @IsTest
    static void newMassRecordInsertListView(){  
        Mass_Record_Update_List_View__c searchItemDataTableListView = Mass_Record_Update_List_View__c.getValues('Selected_Search_Items_View');
        Mass_Record_Update_List_View__c recordItemsDataTableListView = Mass_Record_Update_List_View__c.getValues('Selected_Search_Record_Items_View');
        
        System.debug('searchItemDataTableListView: ' + searchItemDataTableListView);
        System.debug('recordItemsDataTableListView: ' + recordItemsDataTableListView);
        Mass_Record_Update__c newMassUpdate = new Mass_Record_Update__c();
        newMassUpdate.Name = 'Test MassUpdate';
        newMassUpdate.Object_Name__c = 'SR_PR_Notification__c';
        newMassUpdate.Record_Type__c = 'PR One Site';
        //newMassUpdate.Selected_Search_Items_View__c = null;
        //newMassUpdate.Selected_Record_Items_View__c = null;
        System.debug('newMassUpdate.before: ' + newMassUpdate);
        
        
		test.startTest();
        insert newMassUpdate;
        System.debug('newMassUpdate.after: ' + newMassUpdate);    
        test.stopTest();

    }
  
}