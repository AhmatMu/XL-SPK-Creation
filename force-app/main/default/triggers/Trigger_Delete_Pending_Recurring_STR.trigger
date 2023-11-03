trigger Trigger_Delete_Pending_Recurring_STR on Pending_Recurring__c (Before delete) {
if (label.Is_Trigger_Delete_PR_STR_On == 'YES') {
List<Id> PRIds = new List<Id>(); //Pending Recurring
if(Trigger.isBefore && Trigger.isDelete)
    {
        for (Pending_Recurring__c prOld:system.trigger.Old)
        {
            List<Sales_Target_and_Revenue_Detail__c> toDel = new List<Sales_Target_and_Revenue_Detail__c>();
            toDel = [select id from Sales_Target_and_Revenue_Detail__c where Pending_Recurring__c =: prOld.Id];
            if(toDel.size()>0)
            {
                delete toDel;
            }
        }
    }
 }
}