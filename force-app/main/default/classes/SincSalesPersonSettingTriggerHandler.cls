public class SincSalesPersonSettingTriggerHandler {
    private Boolean m_isExecuting = false;
    private Integer batchSize = 0;

    Static Final String SINC_SALES_PERSON_PREFIX_UNIQUEID = 'SETT_PERSON';

    public SincSalesPersonSettingTriggerHandler(Boolean isExecuting, Integer size) {
        m_isExecuting = isExecuting;
        batchSize = size;

    }

    Public void OnBeforeInsert(List < SInc_Sales_Person_Setting__c > newSincSalesPersonList) {
        system.debug('== in  SincSalesPersonSettingTriggerHandler.OnBeforeInsert ==');
        set < String > userEmployeeIds = new Set < String > ();
        List < String > salesPersonUniqueIdList = new List < String > ();
        Boolean doDeleteFirst = true;

        for (SInc_Sales_Person_Setting__c newSincSalesPersonObj: newSincSalesPersonList) {
            userEmployeeIds.add(newSincSalesPersonObj.Employee_ID__c);
        }

        //Get user data
        List < user > userList = new List < user > ();
        if (userEmployeeIds != null) {
            userList = [SELECT ID, Employee_ID__c, userRole.Name, ManagerID, Manager.managerID
                FROM User
                WHERE Employee_ID__c in: userEmployeeIds
            ];

        }

        //putt employe id and sfid into map
        Map < string, user > userMap = new Map < String, user > ();
        for (user userObj: userList) {
            userMap.put(userObj.employee_id__c, userObj);

        }
        system.debug('== userMap :' + userMap);

        for (SInc_Sales_Person_Setting__c newSincSalesPersonObj: newSincSalesPersonList) {
            user userObj = new user();
            String employeeId;

            if (newSincSalesPersonObj.Sales_Person__c == null) {
                //set sales person
                employeeId = newSincSalesPersonObj.employee_id__c;
                userObj = userMap.get(employeeId);
                if (userObj <> null) {
                    newSincSalesPersonObj.Sales_Person__c = userObj.id;
                } else {
                    employeeId = newSincSalesPersonObj.Sales_Person_Rel_Employee_ID__c;
                }
                String year = newSincSalesPersonObj.year__c;
                String Quarter = newSincSalesPersonObj.quarter__c;
                if (year <> null || year <> '') {
                    year = year.right(2);

                    String SincSalesPersonUniqueId = SINC_SALES_PERSON_PREFIX_UNIQUEID + '_' + year + Quarter + '_' + employeeId;

                    system.debug('== SincSalesPersonUniqueId :' + SincSalesPersonUniqueId);
                    if (SincSalesPersonUniqueId <> null) {
                        newSincSalesPersonObj.unique_id__c = SincSalesPersonUniqueId;
                        if (SincSalesPersonUniqueId.length() > 80) {
                            newSincSalesPersonObj.name = SincSalesPersonUniqueId.left(75) + '...';
                        } else {
                            newSincSalesPersonObj.name = SincSalesPersonUniqueId;
                        }
                        salesPersonUniqueIdList.add(SincSalesPersonUniqueId);
                    }
                }

            }

        }
    }
    
    public void OnAfterInsert(List<SInc_Sales_Person_Setting__c> newSincSalesPersonList) {
        system.debug(' in == SincSalesPersonSettingTriggerHandler.OnAfterInsert == ');
        List<ID> IDs= new List<ID> ();
		for (SInc_Sales_Person_Setting__c obj : newSincSalesPersonList) {
			IDs.add(obj.id);
		}
        //-- delete the previous data 
        List<SInc_Sales_Person_Setting__c> spTobeDeleteList = [select id from SInc_Sales_Person_Setting__c where unique_id__c like '%TOBEDELETE'];
        if (spTobeDeleteList.size() >0) {
            delete spTobeDeleteList;
        }
    }
}