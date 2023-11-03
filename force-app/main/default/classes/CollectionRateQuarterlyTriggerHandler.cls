public class CollectionRateQuarterlyTriggerHandler {
    private Boolean m_isExecuting = false;
    private Integer batchSize = 0;

    Static Final String COLLECTION_RATE_QUARTERLY_PREFIX_UNIQUEID = 'CRQ';

    public CollectionRateQuarterlyTriggerHandler(Boolean isExecuting, Integer size) {
        m_isExecuting = isExecuting;
        batchSize = size;

    }


    public void OnBeforeInsert(List<Collection_Rate_Quarterly__c> newCollectionRateQuarterlyList) {
        SYSTEM.DEBUG ('================== IN CollectionRateQuarterlyTriggerHandler.OnBeforeInsert ========');
        
        Set<String> userEmployeeIDS = new Set<String>();
        set<string> userEmails = new set<string>();
        List<String> crqUniqueIDList = new List<String>();
        Boolean doDeleteFirst = true;

        for ( Collection_Rate_Quarterly__c newCollectionRateQuarterlyOBJ : newCollectionRateQuarterlyList ) {

            if(newCollectionRateQuarterlyOBJ.sales_person_email__c != null || newCollectionRateQuarterlyOBJ.sales_person_email__c != ''){
                
                userEmails.add( newCollectionRateQuarterlyOBJ.sales_person_email__c);
                system.debug(' in userEmails ' + userEmails);
            }else{
                userEmployeeIDS.add ( newCollectionRateQuarterlyOBJ.Employee_ID__c );
                system.debug(' in userEmployeeIDS ' + userEmployeeIDS);

            }
        }

        //-- GET Users data -----------------------------------------
        List<User> userList =  new List<User>();
        if (userEmails <> null) {

            userList = [  SELECT ID, Employee_ID__c, email, userRole.Name, ManagerID, Manager.managerID 
                                FROM User 
                                WHERE email in :userEmails
            ];

            
        }else {
            userList = [  SELECT ID, Employee_ID__c, email, userRole.Name, ManagerID, Manager.managerID 
                                FROM User 
                                WHERE Employee_ID__c in :userEmployeeIDS
            ];
        }

        //-- PUT EmployeID and SFID into the Map
        Map<String, User> userMap = new Map<String, User>();
        for (User obj : userList) {
            userMap.put(obj.Employee_ID__c, obj);
        }
        SYSTEM.DEBUG ('======== userMap : ' + userMap );

        //put email and sfid intomap
        Map<String, User> userEmailMap = new Map<string, User>();
        for (User userRec : userList) {
            userEmailMap.put(userRec.email, userRec);
        }
        SYSTEM.DEBUG ('======== userEmailMap : ' + userEmailMap );

        

        for ( Collection_Rate_Quarterly__c newCollectionRateQuarterlyOBJ : newCollectionRateQuarterlyList ) {
            User userObj = new User();
            String employeeID;
            String emailUser;
			if (newCollectionRateQuarterlyOBJ.Sales_Person__c == null) {
                //-- set Sales PErson
			system.debug('employeeID =='+employeeID);
            system.debug('userObj =='+userObj);
                
                if(newCollectionRateQuarterlyOBJ.Sales_Person_Email__c != null || newCollectionRateQuarterlyOBJ.Sales_Person_Email__c != ''){
                    system.debug(' == newCollectionRateQuarterlyOBJ.Sales_Person_Email__c :  ' + newCollectionRateQuarterlyOBJ.Sales_Person_Email__c);
                    emailUser = newCollectionRateQuarterlyOBJ.Sales_Person_Email__c;
                    system.debug('emailUser :  ' + newCollectionRateQuarterlyOBJ.Sales_Person_Email__c);
                    userObj = userEmailMap.get(emailUser);
                    system.debug('=== userEmailMap.get(emailUser) : ' + userEmailMap.get(emailUser));
                    system.debug( ' == email.userObj: ' + userObj);
                    
                }else{
                    employeeID = newCollectionRateQuarterlyOBJ.Employee_ID__c;
				    userObj = userMap.get(employeeID);
                    system.debug( ' == employeid.userObj: ' + userObj);
                }               

                if (userObj <> null) {
                    system.debug(' >> userObj : ' + userObj);
                    newCollectionRateQuarterlyOBJ.Sales_Person__c = userObj.id ;
                }
			} else {
                employeeID = newCollectionRateQuarterlyOBJ.Sales_Person_Rel_Employee_ID__c;
            }

            string year = newCollectionRateQuarterlyOBJ.year__c;
            string quarter = newCollectionRateQuarterlyOBJ.quarter__c;

            if (year <> null && year <> '') {
                year = year.right(2);
            }

            string employeID= '';
            if(userObj.Employee_ID__c != null){
                employeID = userObj.Employee_ID__c;
            }
            
            string crqUniqueID = COLLECTION_RATE_QuarterLY_PREFIX_UNIQUEID + '_' + year + quarter + '_' + employeID;
            
            //-- set unique id 
			System.debug ('=== crqUniqueID : ' + crqUniqueID);
			if (crqUniqueID <> null) {
				newCollectionRateQuarterlyOBJ.Unique_ID__c = crqUniqueID;
                newCollectionRateQuarterlyOBJ.Employee_ID__c = employeID;
                system.debug(' == newCollectionRateQuarterlyOBJ.Employee_ID__c :' +newCollectionRateQuarterlyOBJ.Employee_ID__c);
				if ( crqUniqueID.length() > 80) newCollectionRateQuarterlyOBJ.Name = crqUniqueID.left(75) + ' ...';
					else newCollectionRateQuarterlyOBJ.Name = crqUniqueID;
			}

            crqUniqueIDList.add (crqUniqueID);

        }

        if (doDeleteFirst && crqUniqueIDList.size()>0) {
            //-- delete first
            List<Collection_Rate_Quarterly__c> crqTobeDeleteList = [select id , unique_id__c from Collection_Rate_Quarterly__c where unique_id__c in : crqUniqueIDList];
            if (crqTobeDeleteList.size() >0) {
                //delete strTobeDeleteList;

                for (Collection_Rate_Quarterly__c crqTobeDelete : crqTobeDeleteList) {
                    crqTobeDelete.unique_id__c = crqTobeDelete.unique_id__c + ' TOBEDELETE';
                }
                update crqTobeDeleteList;
            }
        }


        

    }

    public void OnAfterInsert(List<Collection_Rate_Quarterly__c> newCollectionRateQuarterlyList) {
        List<ID> IDs= new List<ID> ();
		for (Collection_Rate_Quarterly__c obj : newCollectionRateQuarterlyList) {
			IDs.add(obj.id);
		}


        //-- delete the previous data 
        List<Collection_Rate_Quarterly__c> crqTobeDeleteList = [select id from Collection_Rate_Quarterly__c where unique_id__c like '%TOBEDELETE'];
        if (crqTobeDeleteList.size() >0) {
            delete crqTobeDeleteList;
        }
    }

    @Future public static void OnAfterInsertAsync(Set<Id> newCollectionRateQuarterlyIDs) {
    }
//system.debug('=====================newCollectionRateQuarterlyIDs'+ newCollectionRateQuarterlyIDs);
    public void OnBeforeUpdate(List<Collection_Rate_Quarterly__c> oldCollectionRateQuarterlyList, List<Collection_Rate_Quarterly__c> updatedCollectionRateQuarterlyList, Map<Id, Collection_Rate_Quarterly__c> oldCollectionRateQuarterlyMap, Map<Id, Collection_Rate_Quarterly__c> newCollectionRateQuarterlyMap) {
    }

    public void OnAfterUpdate(List<Collection_Rate_Quarterly__c> oldCollectionRateQuarterlyList, List<Collection_Rate_Quarterly__c> updatedCollectionRateQuarterlyList, Map<Id, Collection_Rate_Quarterly__c> oldCollectionRateQuarterlyMap, Map<Id, Collection_Rate_Quarterly__c> newCollectionRateQuarterlyMap) {

    }

    @Future public static void OnAfterUpdateAsync(Set<Id> updatedCollectionRateQuarterlyIDs) {
    }

    public void OnBeforeDelete(List<Collection_Rate_Quarterly__c> collectionRateQuarterlyListToDelete, Map<Id, Collection_Rate_Quarterly__c> salesRevnenuMap) {

        System.debug ('=== before delete ==== ');
        System.debug ('=== CollectionRateQuarterlyListToDelete : ' + CollectionRateQuarterlyListToDelete);
        

    }

    public void OnAfterDelete(List<Collection_Rate_Quarterly__c> deletedCollectionRateQuarterlyList, Map<Id, Collection_Rate_Quarterly__c> collectionRateQuarterlyMap) {

    }

    @Future public static void OnAfterDeleteAsync(Set<Id> deletedSalesTargetIDs) {

    }

    public void OnUndelete(List<Collection_Rate_Quarterly__c> restoredCollectionRateQuarterlyList) {

    }

    public Boolean IsTriggerContext {
        get {
            return m_isExecuting;
        }
    }

    public Boolean IsVisualforcePageContext {
        get {
            return !IsTriggerContext;
        }
    }

    public Boolean IsWebServiceContext {
        get {
            return !IsTriggerContext;
        }
    }

    public Boolean IsExecuteAnonymousContext {
        get {
            return !IsTriggerContext;
        }
    }
}