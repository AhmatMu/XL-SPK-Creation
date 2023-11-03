public with sharing class TA_AT_SetSelectedSearchItemsView implements TriggerAction.BeforeInsert {
    public void BeforeInsert(list<Mass_Record_Update__c> massRecordUpateList){
        system.debug('----TA_AT_SetSelectedSearchItemsView.BeforeInsert----');
         
        string errorMsg;
        try {
            Mass_Record_Update_List_View__c searchItemDataTableListView = Mass_Record_Update_List_View__c.getValues('Selected_Search_Items_View');
            Mass_Record_Update_List_View__c recordItemsDataTableListView = Mass_Record_Update_List_View__c.getValues('Selected_Search_Record_Items_View');

            list<Mass_Record_Update__c> udpateMassRecordUpdateListView = new list<Mass_Record_Update__c> ();
            for (Mass_Record_Update__c massRecordUpateListRec : massRecordUpateList) {
                massRecordUpateListRec.Selected_Search_Items_View__c = searchItemDataTableListView.Selected_List_View__c;
                massRecordUpateListRec.Selected_Record_Items_View__c = recordItemsDataTableListView.Selected_List_View__c;
                
                udpateMassRecordUpdateListView.add(massRecordUpateListRec);
            }
            update udpateMassRecordUpdateListView;

        } catch (Exception e) {
            errorMsg = errorMsg + '. Error on TA_AT_SetSelectedSearchItemsView Before Insert' + e.getMessage() + ' - ' + e.getStackTraceString() + e.getLineNumber();
            apputils.putError(errorMsg);
            system.debug('==== errorMsg :' + errorMsg);
        }

    }
}