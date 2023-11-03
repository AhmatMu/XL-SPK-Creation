/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 04-26-2022
 * @last modified by  : Diky Nurosid
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   21-09-2021   Doddy Prima   Initial Version
**/

public class SalesPerformanceController  {
	Static Final String SALES_PERFORMANCE_PREFIX_UNIQUEID = 'SPR';
	//Static Final String SALES_PERFORMANCE_MONTHLY_AMGS_PREFIX_UNIQUEID = 'SPR_MAMGS';
	//Static Final String SALES_PERFORMANCE_MONTHLY_AM_PREFIX_UNIQUEID = 'SPR_MAM';
	
	Static Final String SALES_TARGET_PREFIX_UNIQUEID = 'STR';
	Static Final String SALES_REVENUE_PREFIX_UNIQUEID = 'SRV';


	public void salesPerformanceController () { 


	}

	/**
	 * purpose : 
	 * return  : Map<String, Sales_Performance_Monthly_AMGS__c>
	 *			 Map<[SALES_PERFORMANCE_UNIQUE_ID], [SALES-PERFOMANCE-OBJECT]>
	 */

	public Map<String, String> createSalesPerformanceRecordsBasedOnSalesTargets (
				List<Sales_Target__c> salesTargetList) {
		
		System.debug('== in SalesPerformanceController.createSalesPerformanceRecordsBasedOnSalesTargets');
		
		String relatedSFIDs;
		String errorMsg;

		//Map<String, Sales_Performance_Monthly_AMGS__c> salesPerformanceMap = new Map<String, Sales_Performance_Monthly_AMGS__c>();
		Map<String, String> salesPerformanceMap = new Map<String, String>();
		List<String> salesPerformanceUniqueIDLIst = new List <String>();
		List<Sales_Performance_Monthly_AMGS__c> salesPerformanceM_AM_GS_List = new List <Sales_Performance_Monthly_AMGS__c>();
		List<Sales_Performance_Monthly_AM__c> salesPerformanceM_AM_List = new List <Sales_Performance_Monthly_AM__c>();
		
		Map<String, String> sprM_AM_GS_UniqueIDMAP = new Map<String, String>();
		Map<String, String> sprM_AM_UniqueIDMAP = new Map<String, String>();
		
		Set<String> AMEmployeeIDS = new Set<String>();
		Set<String> SMEmployeeIDS = new Set<String>();
		Set<String> GHEmployeeIDS = new Set<String>();
		Set<String> userEmployeeIDS = new Set<String>();

		Set<String> groupServiceNames = new Set<String>();
		Set<String> revenueCategoryNames = new Set<String>();
		Set<String> segmentNames = new Set<String>();

		Set<String> salesPerformanceNames = new Set<String>();
		Set<String> salesPerformanceUniqueIDs = new Set<String>();

		string AMEmployeeID;
		String SMEmployeeID;
        String GHEmployeeID;
		String userEmployeeID;
        string groupServiceName;
        string sMonth;
        string sYear;
        Date periodDate;
		string sprUniqueID;
		string sprUniqueIDTemp;
		
        string suffixName;


		for ( Sales_Target__c newSalesTargetObj : salesTargetList ) {
			if (newSalesTargetObj.Group_service_name__c <> null && newSalesTargetObj.Group_service_name__c <> '') {
				newSalesTargetObj.Group_service_name__c = newSalesTargetObj.Group_service_name__c.replace('"', '');
			}

			groupServiceNames.add ( newSalesTargetObj.Group_Service_Name__c );

			if(newSalesTargetObj.AM_Employee_ID__c != null){
                userEmployeeID = newSalesTargetObj.AM_Employee_ID__c;
                userEmployeeIDS.add ( newSalesTargetObj.AM_Employee_ID__c );   
                userEmployeeIDS.add ( newSalesTargetObj.AM_Employee_ID__c );
                system.debug('in am == '+userEmployeeIDS);
            }else if(newSalesTargetObj.Sales_Manager_Employee_ID__c != null) {
                userEmployeeID = newSalesTargetObj.Sales_Manager_Employee_ID__c;
                userEmployeeIDS.add ( newSalesTargetObj.Sales_Manager_Employee_ID__c );
                system.debug(' in  SM ==' + userEmployeeIDS);
            }else if(newSalesTargetObj.Group_Head_Employee_ID__c != null){
                userEmployeeID = newSalesTargetObj.Group_Head_Employee_ID__c;
                userEmployeeIDS.add ( newSalesTargetObj.Group_Head_Employee_ID__c );
                system.debug('in gh ==' + userEmployeeIDS);
            }
		}					

        //-- GET Group Service data-----------------------------------------------
        List<Group_Service__c> groupServiceList =  
                                [ SELECT ID, name, type__c
                                    FROM Group_Service__c 
                                    WHERE Name in :groupServiceNames
        ];
        //-- PUT NAME and SFID into the Map
        Map<String, Group_Service__C> groupServiceMap = new Map<String, Group_Service__C>();
        for (Group_Service__C obj : groupServiceList) {
            groupServiceMap.put(obj.Name.toUpperCase(), obj);
        }
        SYSTEM.DEBUG ('======== groupServiceMap : ' + groupServiceMap );
        //-------------------------------------------------------------------------------------

        //-- GET Users data -----------------------------------------
        List<User> userList =  
        [ SELECT ID, Employee_ID__c, userRole.Name, ManagerID, Manager.managerID, manager.userRole.name, manager.manager.UserRole.name, User.IsActive  
            FROM User 
            WHERE Employee_ID__c in :userEmployeeIDS
        ];
        //-- PUT EmployeID and SFID into the Map
        Map<String, User> userMap = new Map<String, User>();
        for (User obj : userList) {
			userMap.put(obj.Employee_ID__c, obj);

			//put user role name as segment list
			string roleName ='';
			if (obj.userRole <> null) {
				roleName = obj.userRole.Name;
				roleName  = roleName.replace('Group Head - ', '').replace('Head - ', '');
				segmentNames.add (roleName);
			}
        }

        SYSTEM.DEBUG ('======== userMap : ' + userMap );
        SYSTEM.DEBUG ('======== segmentNames : ' + segmentNames );


        //-- GET Segement data -----------------------------------------
        List<Segment__c> segmentList =  
        [ SELECT ID, Name, Group_Segment_Name__c
            FROM Segment__c 
            WHERE name in :segmentNames
        ];
        //-- PUT Segment Name and SFID into the Map
        Map<String, Segment__c> segmentMap = new Map<String, Segment__c>();
        for (Segment__c obj : segmentList ) {
        segmentMap.put(obj.Name, obj);
        }
        SYSTEM.DEBUG ('======== segmentMap : ' + segmentMap );

		
		SYSTEM.DEBUG ('======== salesTargetList.size() : ' + salesTargetList.size() );
		try {
			for ( Sales_Target__c newSalesTargetObj : salesTargetList ) {
				if (newSalesTargetObj.Group_service_name__c <> null && newSalesTargetObj.Group_service_name__c <> '') {
					newSalesTargetObj.Group_service_name__c = newSalesTargetObj.Group_service_name__c.replace('"', '');
				}
				//-- create object
				Sales_Performance_Monthly_AMGS__c sprM_AM_GS_Obj = new Sales_Performance_Monthly_AMGS__c();
				Sales_Performance_Monthly_AM__c sprM_AM_Obj = new Sales_Performance_Monthly_AM__c();
				
/*
				if (newSalesTargetObj.AM_Employee_ID__c <> '') {
					AMEmployeeID =  newSalesTargetObj.AM_Employee_ID__c;
				}

				if (newSalesTargetObj.AM__c <> null) {
					AMEmployeeID = newSalesTargetObj.AM_Rel_Employee_ID__c;
				}
*/
				if (newSalesTargetObj.Group_Service_Name__c <> '') {
					groupServiceName =  newSalesTargetObj.Group_Service_Name__c;
				}
				
				if (newSalesTargetObj.Group_Service__c <> null) {
					groupServiceName = newSalesTargetObj.Group_Service_Rel_Name__c;
				}

				sYear = newSalesTargetObj.Year__c.right(2);
				sMonth = ('0' + newSalesTargetObj.Month__c ).right(2) ;
				periodDate = Date.NewInstance (integer.valueof (newSalesTargetObj.Year__c), integer.valueOf(sMonth), 1 );
				string recordTypeName;
				//suffixName = newSalesTargetObj.type__c.replace('Target ','').replace(' ','');
				
				switch on (newSalesTargetObj.type__c) {
					when 'Target Revenue' {
						sprUniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
							sYear + sMonth + '_' +
							userEmployeeID + '_' +
							groupServiceName 
							// + '_'+ suffixName
							;
						
						string groupServiceNameTEMP;
						if (groupServiceName <> null) {
							groupServiceNameTEMP = groupServiceName.toUpperCase();
						}

						Group_Service__c groupServiceOBJ = groupServiceMap.get(groupServiceNameTEMP);
						if (groupServiceOBJ <> null) {
							sprM_AM_GS_Obj.Group_Service__c = groupServiceOBJ.id;
							sprM_AM_GS_Obj.Group_Service_Type__c = groupServiceOBJ.type__c;
						}

						recordTypeName = 'Monthly AM GS';


					}

					when 'Target Revenue (Partnership)', 'Target Partnership Number' {
						sprUniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
							sYear + sMonth + '_' +
							userEmployeeID 
							;
						/*
						sprM_AM_GS_UniqueID = SALES_PERFORMANCE_MONTHLY_AM_PREFIX_UNIQUEID + '_' +
							sYear + sMonth + '_' +
							AMEmployeeID 
							;

						recordTypeName = 'Monthly AM';
						*/

					}				
					

					when 'Target Add Link', 'Target Add Subscribe', 'Target Pipeline', 'Target Pipeline PO',
						 'Target Pipeline New Revenue', 'Target Pipeline BAU' {
						sprUniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
							sYear + sMonth + '_' +
							userEmployeeID 
							//+ '_' + suffixName
							;

						recordTypeName = 'Monthly AM';
					}


				}
				system.System.debug('=== sprUniqueID after set : '+ sprUniqueID);

				
				//string recordTypeName = newSalesTargetObj.type__c.replace('Target ','');
				//-- SET Record Type by TYPE

				RecordTypeInfo recordSPRM_AM_GS_TypeInfoObj = Schema.SObjectType.Sales_Performance_Monthly_AMGS__c.getRecordTypeInfosByName().get(recordTypeName);
				RecordTypeInfo recordTypeSPRM_AM_InfoObj = Schema.SObjectType.Sales_Performance_Monthly_AM__c.getRecordTypeInfosByName().get('Monthly AM');
				
				if (recordSPRM_AM_GS_TypeInfoObj <> null) {
					Id recordTypeId = recordSPRM_AM_GS_TypeInfoObj.getRecordTypeId();
					if (recordTypeId<>null) sprM_AM_GS_Obj.recordtypeid = recordTypeId; 
				}

				if (recordTypeSPRM_AM_InfoObj <> null) {
					Id recordTypeId = recordTypeSPRM_AM_InfoObj.getRecordTypeId();
					if (recordTypeId<>null) sprM_AM_Obj.recordtypeid = recordTypeId; 
				}

				ID AMSFID, SMSFID, GHSFID, segmentSFID;
		
				User amObj = new User();
				User smObj = new User();
				User ghObj = new User();
				
				if(newSalesTargetObj.AM__c <> null || (newSalesTargetObj.AM_Employee_ID__c <> null && newSalesTargetObj.AM_Employee_ID__c <> '')){
					system.debug('in ada di AM == ');
					
					if (newSalesTargetObj.AM_Employee_ID__c <> '' || newSalesTargetObj.AM_Employee_ID__c <> null) {
						AMEmployeeID =  newSalesTargetObj.AM_Employee_ID__c;
						userEmployeeID = newSalesTargetObj.AM_Employee_ID__c;
					}
		
					if (newSalesTargetObj.AM__c <> null) {
						AMEmployeeID = newSalesTargetObj.AM_Rel_Employee_ID__c;
						userEmployeeID = newSalesTargetObj.AM_Employee_ID__c;
					}
	
					if (newSalesTargetObj.AM__c == null) {
						system.debug(' in sini am null == ');
						amObj = userMap.get(AMEmployeeID);
						system.debug(' target.amObj == :' + amObj);
						if (amObj <> null) {
							system.debug('in amobj == ');
							newSalesTargetObj.AM__c = amObj.id ;
							AMSFID = amObj.id;
							newSalesTargetObj.AM_EMployee_ID__c = amObj.Employee_ID__c;

							system.debug('== amObj.ManagerId : ' + amObj.ManagerId);
							system.debug('== amObj.id : ' + amObj.id);
							system.debug('== amObj.Manager.ManagerId : ' + amObj.Manager.ManagerId );

							if(amObj.managerid != null && amObj.UserRole != null){

								if(amObj.manager.userRole.name.contains('Group Head')){
									newSalesTargetObj.Group_Head__c = amObj.ManagerId;
									GHSFID = amObj.ManagerId;
									
								}else if(amObj.manager.userRole.name.contains('Head')){
									newSalesTargetObj.Sales_Manager__c = amObj.ManagerId;
									SMSFID = amObj.ManagerId;
									newSalesTargetObj.Group_Head__c = amObj.Manager.ManagerId;
									GHSFID = amObj.Manager.ManagerId;
								}
							}
										
							system.debug('== newSalesTargetObj.AM__c : ' + newSalesTargetObj.AM__c);
							system.debug('== newSalesTargetObj.Group_Head__c : ' + newSalesTargetObj.Group_Head__c);
							system.debug('== newSalesTargetObj.Sales_Manager__c = : ' + newSalesTargetObj.Sales_Manager__c );
							
		 
							//-- set Segment
							if (amObj.userRole <> null) {
								string roleName = amObj.userRole.Name;
								if (roleName <> null && roleName <> '') {
									roleName  = roleName.replace('Head - ', '').replace('Group Head - ', '');
									
									Segment__c segementObj = segmentMap.get(roleName);
									if (segementObj <> null) {
										newSalesTargetObj.Segment__c = segementObj.id;
										segmentSFID = segementObj.id;
									}
								}
							}
						}
		 
					} 
				}
	
				else if(newSalesTargetObj.Sales_Manager__c <> null || (newSalesTargetObj.Sales_Manager_Employee_ID__c <> null && newSalesTargetObj.Sales_Manager_Employee_ID__c <> '')){
					
					if (newSalesTargetObj.Sales_Manager_Employee_ID__c <> '' || newSalesTargetObj.Sales_Manager_Employee_ID__c <> null) {
						SMEmployeeID =  newSalesTargetObj.Sales_Manager_Employee_ID__c;
						userEmployeeID = newSalesTargetObj.Sales_Manager_Employee_ID__c;
					}
		
					if (newSalesTargetObj.Sales_Manager__c <> null) {
						SMEmployeeID = newSalesTargetObj.AM_Rel_Employee_ID__c;
						userEmployeeID = newSalesTargetObj.Sales_Manager_Employee_ID__c;
					}
	
					if (newSalesTargetObj.Sales_Manager__c == null) {
						smObj = userMap.get(SMEmployeeID);
		
						if (smObj <> null) {
							   
							//-- set Sales Manager
							newSalesTargetObj.Sales_Manager__c = smObj.id;
		
							//-- Set Group Head
							if (smObj.Manager <> null) 
								newSalesTargetObj.Group_Head__c = smObj.ManagerId;
						
		 
							//-- set Segment
							if (smObj.userRole <> null) {
								string roleName = smObj.userRole.Name;
								if (roleName <> null && roleName <> '') {
									roleName  = roleName.replace('Head - ', '').replace('Group Head - ', '');
									
									Segment__c segementObj = segmentMap.get(roleName);
									if (segementObj <> null) {
										newSalesTargetObj.Segment__c = segementObj.id;
									}
								}
							}
						}
		 
					} 
				}
	
				else if(newSalesTargetObj.Group_Head__c <> null || (newSalesTargetObj.Group_Head_Employee_ID__c <> null && newSalesTargetObj.Group_Head_Employee_ID__c <> '')){
					if (newSalesTargetObj.Group_Head_Employee_ID__c <> '' || newSalesTargetObj.Group_Head_Employee_ID__c <> null) {
						GHEmployeeID =  newSalesTargetObj.Group_Head_Employee_ID__c;
						userEmployeeID = newSalesTargetObj.Group_Head_Employee_ID__c;
					}
	
					if (newSalesTargetObj.Group_Head__c <> null) {
					//	GHEmployeeID = newSalesTargetObj.GH_Rel_Employee_ID__c;
					//	userEmployeeID = newSalesTargetObj.Group_Head_Employee_ID__c;
					}
	
					if (newSalesTargetObj.Group_Head__c == null) {
						ghObj = userMap.get(GHEmployeeID);
	
						if (ghObj <> null) {
						//	newSalesTargetObj.Group_Head__c = ghObj.id ;
		
							//-- set Segment
							if (ghObj.userRole <> null) {
								string roleName = ghObj.userRole.Name;
								if (roleName <> null && roleName <> '') {
									roleName  = roleName.replace('Head - ', '').replace('Group Head - ', '');
									
									Segment__c segementObj = segmentMap.get(roleName);
									if (segementObj <> null) {
										newSalesTargetObj.Segment__c = segementObj.id;
									}
								}
							}
						}
		
					} 
				}
				
				/*
				User amObj = userMap.get(AMEmployeeID);
				ID AMSFID, SMSFID, GHSFID, segmentSFID;


				if (amObj <> null) {
					AMSFID = amObj.id ;

					//-- set Sales Manager
					SMSFID = amObj.ManagerId;

					//-- Set Group Head
					if (amObj.Manager <> null) 
						GHSFID = amObj.Manager.ManagerId;

					//-- set Segment
					string roleName = amObj.userRole.Name;
					system.debug('=== roleName : **' + roleName + '**');

					if (roleName <> null && roleName <> '') {
						roleName  = roleName.replace('Group Head - ', '').replace('Head - ', '');
						system.debug('=== roleName : ##' + roleName + '##');

						Segment__c segementObj = segmentMap.get(roleName);
						if (segementObj <> null) {
							segmentSFID = segementObj.id;
						}
					}
				}

*/
				sprM_AM_GS_Obj.Year__c = newSalesTargetObj.Year__c;
				sprM_AM_GS_Obj.Month__c = newSalesTargetObj.Month__c;
				sprM_AM_GS_Obj.Period_Date__c = periodDate;

				

				if (AMSFID <> null) { 
					if (amObj.isActive == true) {
						sprM_AM_GS_Obj.AM__c = AMSFID; 
						sprM_AM_GS_Obj.Sales_Manager__c = SMSFID; 
						sprM_AM_GS_Obj.Group_Head__c = GHSFID;
						sprM_AM_GS_Obj.OwnerID = AMSFID ; 
					} else {
						sprM_AM_GS_Obj.AM__c = AMSFID; 
						sprM_AM_GS_Obj.OwnerID = amObj.managerid ; 
					}
				}else if(SMSFID <> null){
					if(smObj.isActive == true){
						sprM_AM_GS_Obj.Sales_Manager__c = SMSFID; 
						sprM_AM_GS_Obj.Group_Head__c = GHSFID;
						sprM_AM_GS_Obj.OwnerID = SMSFID ;
					}else{
						sprM_AM_GS_Obj.Sales_Manager__c = SMSFID; 
						sprM_AM_GS_Obj.OwnerID = smObj.managerid ;
					}
				}else if(GHSFID <> null){
					if(ghObj.isActive == true){
						sprM_AM_GS_Obj.Group_Head__c = GHSFID; 
						sprM_AM_GS_Obj.OwnerID = GHSFID ;
					}else{
						sprM_AM_GS_Obj.AM__c = GHSFID; 
						sprM_AM_GS_Obj.OwnerID = ghObj.managerid ;
					}
				}
				//-- hanlding if owner is null
				if (sprM_AM_GS_Obj.OwnerID == null ){
					sprM_AM_GS_Obj.OwnerID = userinfo.getUserId();
				} 


				
			//	if (SMSFID <> null) { sprM_AM_GS_Obj.Sales_Manager__c = SMSFID; }
			//	if (GHSFID <> null) { sprM_AM_GS_Obj.Group_Head__c = GHSFID; } 
				if (segmentSFID <> null) { 
					sprM_AM_GS_Obj.Segment__c = segmentSFID; 
				}
				
				sprM_AM_GS_Obj.Unique_ID__c = sprUniqueID;
				if (sprUniqueID.length() > 80) {
					sprM_AM_GS_Obj.Name = sprUniqueID.left(75) + ' ...';
				} else sprM_AM_GS_Obj.Name = sprM_AM_GS_Obj.Unique_ID__c ;

				sprM_AM_Obj.Unique_ID__c = sprUniqueID;
				if (sprUniqueID.length() > 80) {
					sprM_AM_Obj.Name = sprUniqueID.left(75) + ' ...';
				} else sprM_AM_Obj.Name = sprM_AM_GS_Obj.Unique_ID__c ;

				sprM_AM_Obj.ownerid = sprM_AM_GS_Obj.ownerid;
				sprM_AM_Obj.Year__c = sprM_AM_GS_Obj.Year__c;
				sprM_AM_Obj.Month__c = sprM_AM_GS_Obj.Month__c;
				sprM_AM_Obj.Period_Date__c = sprM_AM_GS_Obj.Period_Date__c;
				sprM_AM_Obj.AM__c = sprM_AM_GS_Obj.AM__c;
				sprM_AM_Obj.Sales_Manager__c = sprM_AM_GS_Obj.Sales_Manager__c;
				sprM_AM_Obj.Group_Head__c = sprM_AM_GS_Obj.Group_Head__c;
				sprM_AM_Obj.Segment__c = sprM_AM_GS_Obj.Segment__c;
				sprM_AM_Obj.Unique_ID__c = sprM_AM_GS_Obj.Unique_ID__c;
				sprM_AM_Obj.Name = sprM_AM_GS_Obj.Name;

				
				if ( newSalesTargetObj.type__c == 'Target Revenue' //|| 
						//-- TODO: HARUSNYA YANG DIBAWAH INI NGA MASUK 
						/*
						newSalesTargetObj.type__c == 'Target Add Link' || 
						newSalesTargetObj.type__c == 'Target Add Subscribe' || 
						newSalesTargetObj.type__c == 'Target Pipeline' || 
						newSalesTargetObj.type__c == 'Target Pipeline PO' 
						*/
						) {

					sprUniqueIDTemp = sprM_AM_GS_UniqueIDMAP.get(sprM_AM_GS_Obj.Unique_ID__c);
					system.System.debug('=== sprUniqueIDTemp : '+ sprUniqueIDTemp);
					//-- if there is not in the map then add the unique_id 
					//-- (handling for duplicate sales-performance unique_id in the list)
					if(sprUniqueIDTemp == null){
						salesPerformanceM_AM_GS_List.add(sprM_AM_GS_Obj);
						sprM_AM_GS_UniqueIDMAP.put(sprM_AM_GS_Obj.Unique_ID__c, sprM_AM_GS_Obj.Unique_ID__c);
					}
						
				} 

				if ( newSalesTargetObj.type__c == 'Target Revenue (Partnership)' || 
						newSalesTargetObj.type__c == 'Target Partnership Number' ||
						newSalesTargetObj.type__c == 'Target Add Link' || 
						newSalesTargetObj.type__c == 'Target Add Subscribe' || 
						newSalesTargetObj.type__c == 'Target Pipeline' || 
						newSalesTargetObj.type__c == 'Target Pipeline PO' ||
						newSalesTargetObj.type__c == 'Target Pipeline New Revenue' ||
						newSalesTargetObj.type__c == 'Target Pipeline BAU'
						) {
					
					sprUniqueIDTemp = sprM_AM_UniqueIDMAP.get(sprM_AM_Obj.Unique_ID__c);
					system.System.debug('=== sprUniqueIDTemp : '+ sprUniqueIDTemp);
					//-- if there is not in the map then add the unique_id 
					//-- (handling for duplicate sales-performance unique_id in the list)
					if(sprUniqueIDTemp == null){
						salesPerformanceM_AM_List.add(sprM_AM_Obj);
						sprM_AM_UniqueIDMAP.put(sprM_AM_Obj.Unique_ID__c, sprM_AM_GS_Obj.Unique_ID__c);
					}
					
				}
	
				system.debug('=== sprM_AM_GS_Obj : ' + sprM_AM_GS_Obj);
                system.debug('============= sprM_AM_GS_UniqueIDMAP : '+  sprM_AM_GS_UniqueIDMAP);

				system.debug('=== sprM_AM_Obj : ' + sprM_AM_Obj);
                system.debug('============= sprM_AM_UniqueIDMAP : '+  sprM_AM_UniqueIDMAP);
		
			}

			system.debug('=== salesPerformanceM_AM_GS_List : ' + salesPerformanceM_AM_GS_List);
			system.debug('=== salesPerformanceM_AM_List : ' + salesPerformanceM_AM_List);
			
			upsert salesPerformanceM_AM_GS_List Unique_ID__c;
			upsert salesPerformanceM_AM_List Unique_ID__c;


			for (Sales_Performance_Monthly_AMGS__c sprM_AM_GS_Obj : salesPerformanceM_AM_GS_List) {
				salesPerformanceMap.put (sprM_AM_GS_Obj.unique_id__c + 'MAMGS', sprM_AM_GS_Obj.id);
			}
			for (Sales_Performance_Monthly_AM__c sprM_AM_OBJ : salesPerformanceM_AM_List) {
				salesPerformanceMap.put (sprM_AM_OBJ.unique_id__c + 'MAM', sprM_AM_OBJ.id);
			}



		}

		catch (Exception e) {
            string notes = 'Error on SalesPerformanceController.createSalesPerformanceRecordsBasedOnSalesTargets method.';
            string message =  e.getmessage() + ' - ' +e.getStacktraceString() ;
            integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs;
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
		}


		return salesPerformanceMap;
	}


	/**
	 * purpose : 
	 * return  : Map<String, Sales_Performance_Monthly_AMGS__c>
	 *			 Map<[SALES_PERFORMANCE_UNIQUE_ID], [SALES-PERFOMANCE-OBJECT]>
	 */

	public Map<String, String> createSalesPerformanceRecordsBasedOnSalesRevenues (
				List<Sales_Revenue__c> salesRevenueList) {
		
		System.debug('== SalesPerformanceController.createSalesPerformanceRecordsBasedOnSalesRevenues');
		
		String relatedSFIDs;
		String errorMsg;

		Map<String, String> salesPerformanceMap = new Map<String, String>();
		List<String> salesPerformanceUniqueIDLIst = new List <String>();
		List<Sales_Performance_Monthly_AMGS__c> salesPerformanceM_AM_GS_List = new List <Sales_Performance_Monthly_AMGS__c>();
		List<Sales_Performance_Monthly_AM__c> salesPerformanceMonthlyList = new List <Sales_Performance_Monthly_AM__c>();
		
		Map<String, String> sprM_AM_GS_UniqueIDMAP = new Map<String, String>();
		Map<String, String> sprM_AM_UniqueIDMAP = new Map<String, String>();
		
		Set<String> AMEmployeeIDS = new Set<String>();
		Set<String> SMEmployeeIDS = new Set<String>();
		Set<String> GHEmployeeIDS = new Set<String>();
		Set<String> userEmployeeIDS = new Set<String>();

		Set<String> groupServiceNames = new Set<String>();
		Set<String> revenueCategoryNames = new Set<String>();
		Set<String> segmentNames = new Set<String>();

		Set<String> salesPerformanceNames = new Set<String>();
		Set<String> salesPerformanceUniqueIDs = new Set<String>();

		string AMEmployeeID;
		String SMEmployeeID;
        String GHEmployeeID;
		String userEmployeeID;
        string groupServiceName ;
		string revenueCategoryName ;
		
        string sMonth;
        string sYear;
        Date periodDate;
		string sprM_AM_GS_UniqueID;
		string sprM_AM_UniqueID;
		string sprUniqueIDTemp;

        string suffixName;


		for ( Sales_Revenue__c newSalesRevenueObj : salesRevenueList ) {
			revenueCategoryNames.add ( newSalesRevenueObj.Revenue_Category_Name__c );
			groupServiceNames.add ( newSalesRevenueObj.Group_Service_Name__c );
			
			if(newSalesRevenueObj.AM_Employee_ID__c != null){
                userEmployeeID = newSalesRevenueObj.AM_Employee_ID__c;
                userEmployeeIDS.add ( newSalesRevenueObj.AM_Employee_ID__c );   
                system.debug('in am == '+userEmployeeIDS);
            }else if(newSalesRevenueObj.Sales_Manager_Employee_ID__c != null) {
                userEmployeeID = newSalesRevenueObj.Sales_Manager_Employee_ID__c;
                userEmployeeIDS.add ( newSalesRevenueObj.Sales_Manager_Employee_ID__c );
                system.debug(' in  SM ==' + userEmployeeIDS);
            }else if(newSalesRevenueObj.Group_Head_Employee_ID__c != null){
                userEmployeeID = newSalesRevenueObj.Group_Head_Employee_ID__c;
                userEmployeeIDS.add ( newSalesRevenueObj.Group_Head_Employee_ID__c );
                system.debug('in gh ==' + userEmployeeIDS);
            }
		}					

        //-- GET Group Service data-----------------------------------------------
		
        List<Group_Service__c> groupServiceList =  
                                [ SELECT ID, name, type__c
                                    FROM Group_Service__c 
                                    WHERE Name in :groupServiceNames
        ];
        //-- PUT NAME and SFID into the Map
        Map<String, Group_Service__C> groupServiceMap = new Map<String, Group_Service__C>();
        for (Group_Service__C obj : groupServiceList) {
            groupServiceMap.put(obj.Name.touppercase(), obj);
        }
        SYSTEM.DEBUG ('======== groupServiceMap : ' + groupServiceMap );
		

		//-- GET Revenue Category data -----------------------------------------
        List<Revenue_Category__c> revenueCategoryList =  
                                [ SELECT ID, Name, Group_Service__c	,  Group_Service__r.name, 
										Group_Service__r.id,
										Group_Service__r.type__c
                                    FROM Revenue_Category__c 
                                    WHERE Name in :revenueCategoryNames
        ];
        //-- PUT NAME and SFID into the Map
        Map<String, Revenue_Category__c> revenueCategoryMap = new Map<String, Revenue_Category__c>();
        for (Revenue_Category__c obj : revenueCategoryList) {
            revenueCategoryMap.put(obj.Name.toUpperCase(), obj);
        }


        //-------------------------------------------------------------------------------------

        //-- GET Users data -----------------------------------------
        List<User> userList =  
        [ SELECT  ID, Employee_ID__c, userRole.Name, ManagerID, Manager.managerID, manager.userRole.name, manager.manager.UserRole.name, User.IsActive  
            FROM User 
            WHERE Employee_ID__c in :userEmployeeIDS
        ];
        //-- PUT EmployeID and SFID into the Map
        Map<String, User> userMap = new Map<String, User>();
        for (User obj : userList) {
			userMap.put(obj.Employee_ID__c, obj);

			//put user role name as segment list
			string roleName ='';
			if (obj.userRole <> null) {
				roleName = obj.userRole.Name;
				roleName  = roleName.replace('Group Head - ', '').replace('Head - ', '');
				segmentNames.add (roleName);
			}
        }

        SYSTEM.DEBUG ('======== userMap : ' + userMap );
        SYSTEM.DEBUG ('======== segmentNames : ' + segmentNames );


        //-- GET Segement data -----------------------------------------
        List<Segment__c> segmentList =  
        [ SELECT ID, Name, Group_Segment_Name__c
            FROM Segment__c 
            WHERE name in :segmentNames
        ];
        //-- PUT Segment Name and SFID into the Map
        Map<String, Segment__c> segmentMap = new Map<String, Segment__c>();
        for (Segment__c obj : segmentList ) {
        segmentMap.put(obj.Name, obj);
        }
        SYSTEM.DEBUG ('======== segmentMap : ' + segmentMap );

		
		SYSTEM.DEBUG ('======== salesRevenueList.size() : ' + salesRevenueList.size() );
		try {
			for ( Sales_Revenue__c newSalesRevenueObj : salesRevenueList ) {
				if (newSalesRevenueObj.Revenue_Category_Name__c <> null && newSalesRevenueObj.Revenue_Category_Name__c <> '') {
					newSalesRevenueObj.Revenue_Category_Name__c =  newSalesRevenueObj.Revenue_Category_Name__c.replace('"', '');
				}
				if (newSalesRevenueObj.Group_service_name__c <> null && newSalesRevenueObj.Group_service_name__c <> '') {
					newSalesRevenueObj.Group_service_name__c = newSalesRevenueObj.Group_service_name__c.replace('"', '');
				}
				//-- create object
				Sales_Performance_Monthly_AMGS__c sprM_AM_GS_Obj = new Sales_Performance_Monthly_AMGS__c();
				Sales_Performance_Monthly_AM__c sprM_AM_Obj = new Sales_Performance_Monthly_AM__c();
			
				
				if (newSalesRevenueObj.Revenue_Category_Name__c <> '') {
					revenueCategoryName =  newSalesRevenueObj.Revenue_Category_Name__c;
				}
				
				if (newSalesRevenueObj.Revenue_Category__c <> null) {
					revenueCategoryName = newSalesRevenueObj.Revenue_Category_Rel_Name__c;
				}

				sYear = newSalesRevenueObj.Year__c.right(2);
				sMonth = ('0' + newSalesRevenueObj.Month__c ).right(2) ;
				periodDate = Date.NewInstance (integer.valueof (newSalesRevenueObj.Year__c), integer.valueOf(sMonth), 1 );


				string revenueCategoryNameTEMP;
				if (revenueCategoryName <> null) {
					revenueCategoryNameTEMP = revenueCategoryName.toUpperCase();
				}

				Revenue_Category__c revenueCategoryOBJ = revenueCategoryMap.get( revenueCategoryNameTEMP );
				if (revenueCategoryOBJ <> null) {
					sprM_AM_GS_Obj.Group_Service__c = revenueCategoryOBJ.GRoup_Service__r.id;
					sprM_AM_GS_Obj.Group_Service_Type__c = revenueCategoryOBJ.GRoup_Service__r.type__c;
					groupServiceName  = revenueCategoryOBJ.GRoup_Service__r.name;
				}

				if (newSalesRevenueObj.group_service_name__c <> '' && newSalesRevenueObj.group_service_name__c <> null) {
					groupServiceName = newSalesRevenueObj.group_service_name__c ;

					string groupServiceNameTEMP;
					if (groupServiceName <> null) {
						groupServiceNameTEMP = groupServiceName.toUpperCase();
					}

					Group_Service__c groupServiceOBJ = groupServiceMap.get(groupServiceNameTEMP);
					if (groupServiceOBJ <> null) {
						sprM_AM_GS_Obj.Group_Service__c = groupServiceOBJ.id;
						sprM_AM_GS_Obj.Group_Service_Type__c = groupServiceOBJ.type__c;
					}
				}



				//suffixName = newSalesRevenueObj.type__c.replace('Target ','').replace(' ','');
				system.debug ('== newSalesRevenueObj : ' + newSalesRevenueObj);
				system.debug ('== newSalesRevenueObj.type__c : ' + newSalesRevenueObj.type__c);
				string recordTypeName;
				switch on (newSalesRevenueObj.type__c) {
					when 'Actual Revenue',
						 'Forecast Revenue Recurring', 
						 'Forecast Revenue Pending Recurring', 
						 'Forecast Waiving',
						 'Opportunity Product yymm-am-gs' {
						

						
						//suffixName = 'Revenue';
						sprM_AM_GS_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
							sYear + sMonth + '_' +
							userEmployeeID + '_' +
							groupServiceName ;
						
						recordTypeName = 'Monthly AM GS'; //'Revenue';

						sprM_AM_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
							sYear + sMonth + '_' +
							userEmployeeID ;

					}
					when 'Opportunity Product yymm-am', 
						 'Pipeline PO',
						 'Link Churn',
						 'Link Gross Add',
						 'Subscribe Churn',
						 'Subscribe Gross Add' {

						//suffixName = newSalesRevenueObj.type__c;
						sprM_AM_GS_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
							sYear + sMonth + '_' +
							userEmployeeID ;
						
						recordTypeName = 'Monthly AM';

						sprM_AM_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
							sYear + sMonth + '_' +
							userEmployeeID ;
						
					}

					when 'Actual Revenue M-Ads Enterprise', 
						 'Actual Revenue M-Ads ADAI' {
						sprM_AM_GS_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
							sYear + sMonth ;
						
						recordTypeName = 'Monthly';

						sprM_AM_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
							sYear + sMonth + '_' +
							userEmployeeID ;
						
						/* TODO : handling for monthly data
						sprMUniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
							sYear + sMonth ;*/
					}

					when 'Opportunity Product' {
						suffixName = '';
						sprM_AM_GS_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
							sYear + sMonth + '_' +
							userEmployeeID  + '_' +
							groupServiceName
							;

						sprM_AM_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
							sYear + sMonth + '_' +
							userEmployeeID ;
						
						
						recordTypeName = 'Monthly AM GS';
					}

				}
				system.System.debug('=== sprM_AM_GS_UniqueID after set : '+ sprM_AM_GS_UniqueID);

				//-- SET Record Type by TYPE
				RecordTypeInfo recordSPRM_AM_GS_TypeInfoObj = Schema.SObjectType.Sales_Performance_Monthly_AMGS__c.getRecordTypeInfosByName().get(recordTypeName);
				RecordTypeInfo recordTypeSPRM_AM_InfoObj = Schema.SObjectType.Sales_Performance_Monthly_AM__c.getRecordTypeInfosByName().get('Monthly AM');

				if (recordSPRM_AM_GS_TypeInfoObj <> null) {
					Id recordTypeId = recordSPRM_AM_GS_TypeInfoObj.getRecordTypeId();
					if (RecordTypeId<>null) sprM_AM_GS_Obj.recordtypeid = recordTypeId; 
				}
				if (recordTypeSPRM_AM_InfoObj <> null) {
					Id recordTypeId = recordTypeSPRM_AM_InfoObj.getRecordTypeId();
					if (recordTypeId<>null) sprM_AM_Obj.recordtypeid = recordTypeId; 
				}

			//	User amObj = userMap.get(AMEmployeeID);
				ID AMSFID, SMSFID, GHSFID, segmentSFID;
		
				User amObjs = new User();
				User smObjs = new User();
				User ghObjs = new User();
				
				//-- set AM
			  //  string AMEmployeeID = '';
				System.debug('newSalesRevenueObj.AM__c :' + newSalesRevenueObj.AM__c);
				system.debug(' newSalesRevenueObj.AM_Employee_ID__c == ' + newSalesRevenueObj.AM_Employee_ID__c);
				if (newSalesRevenueObj.AM__c <> null || (newSalesRevenueObj.AM_Employee_ID__c <> null && newSalesRevenueObj.AM_Employee_ID__c != '')) {  
					system.debug('== in AM ==');
					//-- if AM is not null
					amObjs = userMap.get(newSalesRevenueObj.AM_Employee_ID__c);
					system.debug('amObjs ' + amObjs);
					if (amObjs <> null) {
						userEmployeeID = newSalesRevenueObj.AM_Employee_ID__c;
						AMSFID = amObjs.id ;
						
						//-- set Sales Manager
						//SMSFID = amObjs.ManagerId;	
						//-- set Sales Manager
						//GHSFID= amObjs.Manager.ManagerId;
						system.debug(' == amobjs >> ' +amObjs);

						if(amObjs.managerid != null && amObjs.UserRole != null){
							if(amObjs.Manager.UserRole.name.contains('Group Head')){
								GHSFID = amObjs.ManagerId;
							}else if(amObjs.Manager.UserRole.name.contains('Head')){
								SMSFID = amObjs.ManagerId;	
								GHSFID= amObjs.Manager.ManagerId;
							}	
						}else{
							system.debug('Sales manager kosong');
						}
						
						
						//SMSFID = amObjs.ManagerId;
						
					   //-- Set Group Head
					   	//GHSFID= amObjs.Manager.ManagerId;
						   
						system.debug(' == newSalesRevenueObj.Group_Head__c : ' + GHSFID);
						//-- set Segment
						string roleName = amObjs.userRole.Name;
						system.debug(' roleName :' +roleName);
						if (roleName <> null) {
							roleName  = roleName.replace('Head - ', '').replace('Group Head - ', '');
						}
						segment__c tmpSegementOBJ = segmentMap.get(roleName);
						
						if  (tmpSegementOBJ <> null ) {
							segmentSFID = segmentMap.get(roleName).id;
						}
	
						system.debug(' newSalesRevenueObj = :' + AMSFID + '  | sales manager :  '+ SMSFID + '| Group Head :+ ' + GHSFID);
					}
	
					else if(newSalesRevenueObj.AM__c <> null){
						system.debug('newSalesRevenueObj.AM__c == :' + newSalesRevenueObj.AM__c);
						//-- set AM
						AMEmployeeID = newSalesRevenueObj.AM_Rel_Employee_ID__c;
						userEmployeeID = newSalesRevenueObj.AM_Rel_Employee_ID__c;
						//-- set Sales Manager
						//newSalesRevenueObj.Sales_Manager__c = newSalesRevenueObj.AM_Rel_SM_SFID__c;
					
						//-- Set Group Head
						//newSalesRevenueObj.Group_Head__c = newSalesRevenueObj.AM_Rel_GH_SFID__c;
						//-- set Segment
						Segment__c segmentOBJ = segmentMap.get(newSalesRevenueObj.AM_Rel_Segment__c);
						if (segmentOBJ <> null) {
							segmentSFID = segmentOBJ.id;
						}
					}
				}
				
			   else if(newSalesRevenueObj.Sales_Manager__c <> null || (newSalesRevenueObj.Sales_Manager_Employee_ID__c <> null && newSalesRevenueObj.Sales_Manager_Employee_ID__c != '')){
					system.debug('== in SM ==');
					smObjs = userMap.get(newSalesRevenueObj.Sales_Manager_Employee_ID__c);
					system.debug(' == smObjs :' + smObjs);
					system.debug(' userMap == : ' + userMap );
					if (smObjs <> null) {
						system.debug('in smObjs : ' + smObjs);
						//set sales manager
						SMSFID = smObjs.id ;
					   //-- Set Group Head
					   GHSFID= smObjs.ManagerId;
						//-- set Segment
						string roleName = smObjs.userRole.Name;
						system.debug(' SM roleName : ' + roleName);
						if (roleName <> null) {
							roleName  = roleName.replace('Head - ', '').replace('Group Head - ', '');
						}
						system.debug(' SM roleName afterreplaces : ' + roleName);
						segment__c tmpSegementOBJ = segmentMap.get(roleName);
						
						if  (tmpSegementOBJ <> null ) {
							segmentSFID = segmentMap.get(roleName).id;
						}
					
					}
	
				   else if(newSalesRevenueObj.Sales_Manager__c <> null){
						//-- set AM
						SMEmployeeID = newSalesRevenueObj.SM_Rel_Employee_ID__c;
						userEmployeeID = newSalesRevenueObj.SM_Rel_Employee_ID__c;
						system.debug(' == SMEmployeeID : ' + SMEmployeeID);
						//-- Set Group Head
						GHSFID = newSalesRevenueObj.SM_Rel_GH_SFID__c;
						system.debug('== SM newSalesRevenueObj.Group_Head__c '+ newSalesRevenueObj.Group_Head__c);
						//-- set Segment
						
						system.debug(' == newSalesRevenueObj.SM_Rel_Segment__c : ' + newSalesRevenueObj.SM_Rel_Segment__c);
						system.debug(' == segmentMap.get(newSalesRevenueObj.SM_Rel_Segment__c) :' + segmentMap.get(newSalesRevenueObj.SM_Rel_Segment__c));
						system.debug(' == segmentMap :' + segmentMap);
						Segment__c segmentOBJ = segmentMap.get(newSalesRevenueObj.SM_Rel_Segment__c);
						System.debug('segmentOBJ == :' + segmentOBJ);
						
						if (segmentOBJ <> null) {
							segmentSFID = segmentOBJ.id;
							system.debug(' newSalesRevenueObj.Segment__c : ' + newSalesRevenueObj.Segment__c);
						}
					}
				}
				
			else if(newSalesRevenueObj.Group_Head_Employee_ID__c != '' || newSalesRevenueObj.Group_Head__c <> null){
					System.debug('== in GH ==');
					ghObjs = userMap.get(newSalesRevenueObj.Group_Head_Employee_ID__c);
	
					if (ghObjs <> null) {
						
					   //-- Set Group Head
						newSalesRevenueObj.Group_Head__c = ghObjs.Id;
						//-- set Segment
						
						string roleName = smObjs.userRole.Name;
						system.debug(' SM roleName == ' +  roleName);
						if (roleName <> null) {
							roleName  = roleName.replace('Head - ', '').replace('Group Head - ', '');
						}
						system.debug(' SM roleName after changes == ' +  roleName);
						segment__c tmpSegementOBJ = segmentMap.get(roleName);
						
						if  (tmpSegementOBJ <> null ) {
							segmentSFID = segmentMap.get(roleName).id;
						}
					}
	
				  else if(newSalesRevenueObj.group_head__c <> null){
						//-- set group head
						GHEmployeeID = newSalesRevenueObj.GH_Rel_Employee_ID__c;
						userEmployeeID = newSalesRevenueObj.GH_Rel_Employee_ID__c;
						
						//-- set Segment
						Segment__c segmentOBJ = segmentMap.get(newSalesRevenueObj.GH_Rel_Segment__c);
						if (segmentOBJ <> null) {
							segmentSFID = segmentOBJ.id;
						}
				}
			}
		/*		
			if (newSalesRevenueObj.AM_Employee_ID__c <> '') {
				AMEmployeeID =  newSalesRevenueObj.AM_Employee_ID__c;
			}

			if (newSalesRevenueObj.AM__c <> null) {
				AMEmployeeID = newSalesRevenueObj.AM_Rel_Employee_ID__c;
			}

			

				if (amObj <> null) {
					AMSFID = amObj.id ;

					//-- set Sales Manager
					SMSFID = amObj.ManagerId;

					//-- Set Group Head
					if (amObj.Manager <> null) 
						GHSFID = amObj.Manager.ManagerId;

					//-- set Segment
					string roleName = amObj.userRole.Name;
					if (roleName <> null && roleName <> '') {
						roleName  = roleName.replace('Group Head - ', '').replace('Head - ', '');
						
						Segment__c segementObj = segmentMap.get(roleName);
						if (segementObj <> null) {
							segmentSFID = segementObj.id;
						}
					}
				}*/


				sprM_AM_GS_Obj.Year__c = newSalesRevenueObj.Year__c;
				sprM_AM_GS_Obj.Month__c = newSalesRevenueObj.Month__c;
				sprM_AM_GS_Obj.Period_Date__c = periodDate;

				if (AMSFID <> null) { 
					if (amObjs.isActive == true) {
						sprM_AM_GS_Obj.AM__c = AMSFID; 
						sprM_AM_GS_Obj.Sales_Manager__c = SMSFID; 
						sprM_AM_GS_Obj.Group_Head__c = GHSFID;
						sprM_AM_GS_Obj.OwnerID = AMSFID ; 
					} else {
						sprM_AM_GS_Obj.AM__c = AMSFID; 
						sprM_AM_GS_Obj.OwnerID = amObjs.managerid ; 
					}
				}else if(SMSFID <> null){
					if(smObjs.isActive == true){
						sprM_AM_GS_Obj.Sales_Manager__c = SMSFID; 
						sprM_AM_GS_Obj.Group_Head__c = GHSFID;
						sprM_AM_GS_Obj.OwnerID = SMSFID ;
					}else{
						sprM_AM_GS_Obj.Sales_Manager__c = SMSFID; 
						sprM_AM_GS_Obj.OwnerID = smObjs.managerid ;
					}
				}else if(GHSFID <> null){
					if(ghObjs.isActive == true){
						sprM_AM_GS_Obj.Group_Head__c = GHSFID; 
						sprM_AM_GS_Obj.OwnerID = GHSFID ;
					}else{
						sprM_AM_GS_Obj.AM__c = GHSFID; 
						sprM_AM_GS_Obj.OwnerID = ghObjs.managerid ;
					}
				}
				//-- hanlding if owner is null
				if (sprM_AM_GS_Obj.OwnerID == null ) sprM_AM_GS_Obj.OwnerID = userinfo.getUserId();
				//if (SMSFID <> null) { sprM_AM_GS_Obj.Sales_Manager__c = SMSFID; }
				//if (GHSFID <> null) { sprM_AM_GS_Obj.Group_Head__c = GHSFID; } 
				if (segmentSFID <> null) { sprM_AM_GS_Obj.Segment__c = segmentSFID; }
				
				sprM_AM_GS_Obj.Unique_ID__c = sprM_AM_GS_UniqueID;


				if (sprM_AM_GS_UniqueID.length() > 80) {
					sprM_AM_GS_Obj.Name = sprM_AM_GS_UniqueID.left(75) + ' ...';
				} else sprM_AM_GS_Obj.Name = sprM_AM_GS_Obj.Unique_ID__c ;

				sprUniqueIDTemp = sprM_AM_GS_UniqueIDMAP.get(sprM_AM_GS_Obj.Unique_ID__c);
				system.System.debug('=== sprUniqueIDTemp : '+ sprUniqueIDTemp);
				//-- if there is not in the map then add the unique_id 
				//-- (handling for duplicate sales-performance unique_id in the list)
				if(sprUniqueIDTemp == null){
					salesPerformanceM_AM_GS_List.add(sprM_AM_GS_Obj);
					sprM_AM_GS_UniqueIDMAP.put(sprM_AM_GS_Obj.Unique_ID__c, sprM_AM_GS_Obj.Unique_ID__c);
				}
				
				system.debug('=== sprM_AM_GS_Obj : ' + sprM_AM_GS_Obj);
                system.debug('============= sprM_AM_GS_UniqueIDMAP : '+  sprM_AM_GS_UniqueIDMAP);

				// -- set SALES PERFORMANCE MONTHLY AM <----------------------------------------------------
				sprM_AM_Obj.ownerid = sprM_AM_GS_Obj.ownerid;
				sprM_AM_Obj.Year__c = sprM_AM_GS_Obj.Year__c;
				sprM_AM_Obj.Month__c = sprM_AM_GS_Obj.Month__c;
				sprM_AM_Obj.Period_Date__c = sprM_AM_GS_Obj.Period_Date__c;
				sprM_AM_Obj.AM__c = sprM_AM_GS_Obj.AM__c;
				sprM_AM_Obj.Sales_Manager__c = sprM_AM_GS_Obj.Sales_Manager__c;
				sprM_AM_Obj.Group_Head__c = sprM_AM_GS_Obj.Group_Head__c;
				sprM_AM_Obj.Segment__c = sprM_AM_GS_Obj.Segment__c;
				
				// set name and unique id ...
				sprM_AM_Obj.Unique_ID__c = sprM_AM_UniqueID;
				if (sprM_AM_UniqueID.length() > 80) {
					sprM_AM_Obj.Name = sprM_AM_UniqueID.left(75) + ' ...';
				} else sprM_AM_Obj.Name = sprM_AM_Obj.Unique_ID__c ;

				sprUniqueIDTemp = sprM_AM_UniqueIDMAP.get(sprM_AM_Obj.Unique_ID__c);
				system.System.debug('=== sprUniqueIDTemp : '+ sprUniqueIDTemp);
				//-- if there is not in the map then add the unique_id 
				//-- (handling for duplicate sales-performance unique_id in the list)
				if(sprUniqueIDTemp == null){
					salesPerformanceMonthlyList.add(sprM_AM_Obj);
					sprM_AM_UniqueIDMAP.put(sprM_AM_Obj.Unique_ID__c, sprM_AM_Obj.Unique_ID__c);
				}

				system.debug('=== sprM_AM_Obj : ' + sprM_AM_Obj);
                system.debug('============= sprM_AM_UniqueIDMAP : '+  sprM_AM_UniqueIDMAP);

				// .endOf   set SALES PERFORMANCE MONTHLY AM  <---------------------------------------------
			}

			system.debug('=== salesPerformanceM_AM_GS_List : ' + salesPerformanceM_AM_GS_List);
			upsert salesPerformanceM_AM_GS_List Unique_ID__c;

			system.debug('=== salesPerformanceMonthlyList : ' + salesPerformanceMonthlyList);
			upsert salesPerformanceMonthlyList Unique_ID__c;


			for (Sales_Performance_Monthly_AMGS__c sprM_AM_GS_Obj : salesPerformanceM_AM_GS_List) {
				salesPerformanceMap.put (sprM_AM_GS_Obj.unique_id__c + 'MAMGS', sprM_AM_GS_Obj.id );
			}
			for (Sales_Performance_Monthly_AM__c sprM_AM_Obj : salesPerformanceMonthlyList) {
				salesPerformanceMap.put (sprM_AM_Obj.unique_id__c + 'MAM', sprM_AM_Obj.id);
			}

		}

		catch (Exception e) {
            string notes = 'Error on SalesPerformanceController.createSalesPerformanceRecordsBasedOnSalesTargets method.';
            string message =  e.getmessage() + ' - ' +e.getStacktraceString() ;
            integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs;
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
		}


		return salesPerformanceMap;
	}
	//-- .endOF createSalesPerformanceRecordsBasedOnSalesRevenues


	/**
	 * purpose : 
	 * return  : Map<String, Sales_Performance_Monthly_AMGS__c>
	 *			 Map<[SALES_PERFORMANCE_UNIQUE_ID], [SALES-PERFOMANCE-OBJECT]>
	 */
	/* COBA DITUTUP 
	public Map<String, Sales_Performance_Monthly_AMGS__c> createSalesPerformanceRecordsBasedOnOpportunityLineItems (List<OpportunityLineItem> oliList) {
		system.System.debug('== SalesPerformanceController.createSalesPerformanceRecordsBasedOnOpportunityLineItems');
		String relatedSFIDs;
		String errorMsg;

		Map<String, Sales_Performance_Monthly_AMGS__c> salesPerformanceMap = new Map<String, Sales_Performance_Monthly_AMGS__c>();
		List<String> salesPerformanceUniqueIDLIst = new List <String>();
        List<Sales_Performance_Monthly_AMGS__c> salesPerformanceList = new List <Sales_Performance_Monthly_AMGS__c>();
        Map<String, String> sprMAMGSUniqueIDMAP = new Map<String, String>();


		String recordTypeName = 'Monthly AM GS';
		Id recordTypeAMGSId;
		Id recordTypeAMId;
		
		RecordTypeInfo recordTypeInfoAMGSObj = Schema.SObjectType.Sales_Performance_Monthly_AMGS__c.getRecordTypeInfosByName().get(recordTypeName);
		if (recordTypeInfoAMGSObj <> null) {
			recordTypeAMGSId = recordTypeInfoAMGSObj.getRecordTypeId();
		}

		recordTypeName = 'Monthly AM';
		RecordTypeInfo recordTypeInfoAMObj = Schema.SObjectType.Sales_Performance_Monthly_AMGS__c.getRecordTypeInfosByName().get(recordTypeName);
		if (recordTypeInfoAMObj <> null) {
			recordTypeAMId = recordTypeInfoAMObj.getRecordTypeId();
		}	
		
		
		try {           
            for (OpportunityLineItem oliObj : oliList) {
				system.System.debug('==oliObj :  '+oliObj);
				system.System.debug(' ==oliList' +oliList );
                String year = string.valueOf(oliobj.Actual_Close_Date__c.year());
				String yearf = year.right(2);
                String month = string.valueOf(oliobj.Actual_Close_Date__c.MONTH());
				String Monthf = '0' + month.right(2);
                system.debug('==== yearf month' + yearf + monthf);

                Sales_Performance_Monthly_AMGS__c sprAMGSObj =  new Sales_Performance_Monthly_AMGS__c();
				if (recordTypeAMGSId<>null) sprAMGSObj.recordtypeid = recordTypeAMGSId; 
				
                sprAMGSObj.Unique_ID__c = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' + 
											yearf + monthf + '_' + 
											oliObj.AM_Employee_ID__c + '_'  + 
											oliObj.Group_Service_Name__c;
                
				if (sprAMGSObj.Unique_ID__c.length () >80)
					sprAMGSObj.name = sprAMGSObj.Unique_ID__c.left(75) + ' ...';
				else sprAMGSObj.name = sprAMGSObj.Unique_ID__c;

                String ownerid = oliObj.AM_SFID__c; 
				
				if (oliObj.owner_is_active__c ) {
                	sprAMGSObj.OwnerId = oliObj.AM_SFID__c;
					sprAMGSObj.AM__c = oliObj.AM_SFID__c;
				} else {
					sprAMGSObj.OwnerId = oliObj.SM_SFID__c;
					sprAMGSObj.AM__c = null;
				}

				
                sprAMGSObj.Group_Service__c = oliObj.Group_Service_SFID__c;
				sprAMGSObj.Group_Service_Type__c = oliObj.Group_Service_Type__c;
				
                sprAMGSObj.Sales_Manager__c = oliObj.SM_SFID__c;
                sprAMGSObj.Group_Head__c = oliObj.GH_SFID__c;
                
				
				sprAMGSObj.Year__c = year;
                sprAMGSObj.Month__c = month;
                sprAMGSObj.Period_Date__c = oliobj.Actual_Close_Date__c.toStartOfMonth();

                String sprUniqueID = sprMAMGSUniqueIDMAP.get(sprAMGSObj.Unique_ID__c);
				system.System.debug('===sprUniqueID : '+ sprUniqueID);
                //-- if there is not in the map then add the unique_id 
				//-- (handling for duplicate sales-performance unique_id in the list)
				if(sprUniqueID == null){
					system.System.debug('=== sprAMGSObj :' +sprAMGSObj); 
                    salesPerformanceList.add(sprAMGSObj);
                    sprMAMGSUniqueIDMAP.put(sprAMGSObj.Unique_ID__c, sprAMGSObj.Unique_ID__c);
                }



				//-- set 2nd Sales Performance -------------------------------------------------------------
				Sales_Performance_Monthly_AMGS__c sprAMObj =  new Sales_Performance_Monthly_AMGS__c();

				system.System.debug('=== before clone sprAMGSObj :' +sprAMObj); 
				sprAMObj = sprAMGSObj.clone(false, true, false, false);
				system.System.debug('=== after clone sprAMObj :' +sprAMObj); 

				if (recordTypeAMId<>null) sprAMObj.recordtypeid = recordTypeAMId; 

				sprAMObj.Unique_ID__c = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' + 
											yearf + monthf + '_' + 
											oliObj.AM_Employee_ID__c ;

				if (sprAMObj.Unique_ID__c.length () >80)
				sprAMObj.name = sprAMObj.Unique_ID__c.left(75) + ' ...';
				else sprAMObj.name = sprAMObj.Unique_ID__c;

				sprAMObj.Group_Service__c = null;
				sprAMObj.Group_Service_Type__c = '';

				sprUniqueID = sprMAMGSUniqueIDMAP.get(sprAMObj.Unique_ID__c);
				system.System.debug('===sprUniqueID : '+ sprUniqueID);
                //-- if there is not in the map then add the unique_id 
				//-- (handling for duplicate sales-performance unique_id in the list)
				if(sprUniqueID == null){
					system.System.debug('=== sprAMObj :' +sprAMObj); 
                    salesPerformanceList.add(sprAMObj);
                    sprMAMGSUniqueIDMAP.put(sprAMObj.Unique_ID__c, sprAMObj.Unique_ID__c);
                }



                system.debug('============= salesPerformanceList : '+ salesPerformanceList);
                system.debug('============= sprMAMGSUniqueIDMAP : '+  sprMAMGSUniqueIDMAP);
			}

			//-- do upsert the sales performance data list with unique_id
            upsert salesPerformanceList Unique_ID__c;
			

			//-- add sales-performnce data into the return map
			for (Sales_Performance_Monthly_AMGS__c sprObj :  salesPerformanceList) {
				//-- put unique_id as the key, and sprObj as the value 
				system.debug('============= sprObj to map : '+  sprObj);
				salesPerformanceMap.put ( sprObj.Unique_ID__c, sprObj);

			}


			//-- TODO: create Sales Performance Workspace records
			//-- call method in SalesPerformanceWorkspaceController 
			 

		}

		catch (Exception e) {
            string notes = 'Error on SalesPerformanceController.createSalesPerformanceRecordsBasedOnOpportunityLineItems method.';
            string message =  e.getmessage() + ' - ' +e.getStacktraceString() ;
            integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs;
            apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
		}
        
		
		//-- return the map of Sales-Performance <unique_id, salesPerformanceObj>
		system.debug ('===== salesPerformanceMap : ' + salesPerformanceMap);
		return salesPerformanceMap;
	}
	*/


	//-- SAAT INI TIDAK DIGUNAKAN
	/*
	public Map<String, Sales_Performance_Monthly_AMGS__c> createSalesPerformanceRecordsBasedOnPendingRecurrings (
				List<Pending_Recurring__c> objList) {

		String relatedSFIDs;
		String errorMsg;

		Map<String, Sales_Performance_Monthly_AMGS__c> salesPerformanceMap = new Map<String, Sales_Performance_Monthly_AMGS__c>();
		List<String> salesPerformanceUniqueIDLIst = new List <String>();
        List<Sales_Performance_Monthly_AMGS__c> salesPerformanceList = new List <Sales_Performance_Monthly_AMGS__c>();
        Map<String, String> sprMAMGSUniqueIDMAP = new Map<String, String>();

		/* the logic
			TODO: do write the logic
		
		*/


		//-- return the map of Sales-Performance <unique_id, obj>
		/*return salesPerformanceMap;
	
	}*/

	//-- SAAT INI TIDAK DIGUNAKAN
	/*
	public Map<String, Sales_Performance_Monthly_AMGS__c> createSalesPerformanceRecordsBasedOnEDAs (
				List<EDA__c> objList) {

		String relatedSFIDs;
		String errorMsg;
		
		set<String> groupServiceNames = new Set<String>();
		for (EDA__c edaObj : objList) {
			groupServiceNames.add(edaObj.Group_Service_Name__c);
		}

		//-- GET Group Services data -----------------------------------------
        List<Group_Service__c> groupServiceList =  
                                [ SELECT ID, Name 
                                    FROM Group_Service__c 
                                    WHERE Name in :groupServiceNames
        ];
		//-- PUT NAME and SFID into the Map
        Map<String, String> groupServiceMap = new Map<String, String>();
        for (Group_Service__c obj : groupServiceList) {
            groupServiceMap.put(obj.Name.toUppercase(), obj.ID);
			system.debug('=== groupServiceMap : ' + groupServiceMap); 
        }
		system.debug('=== groupServiceMap : ' + groupServiceMap);


		//Map<String, Sales_Performance_Monthly_AMGS__c> salesPerformanceMap = new Map<String, Sales_Performance_Monthly_AMGS__c>();
		//List<String> salesPerformanceUniqueIDLIst = new List <String>();
        //List<Sales_Performance_Monthly_AMGS__c> salesPerformanceList = new List <Sales_Performance_Monthly_AMGS__c>();
       // Map<String, String> sprMAMGSUniqueIDMAP = new Map<String, String>();

		List<Sales_Performance_Monthly_AMGS__c> salesPerformanceList = new List <Sales_Performance_Monthly_AMGS__c>();
		Map<String, Sales_Performance_Monthly_AMGS__c> salesPerformanceMap = new map<String, Sales_Performance_Monthly_AMGS__c> (); 
		Map<String, String> sprMAMGSUniqueIDMAP = new Map<String, String>();

		//-- SET Record Type by TYPE
		String recordTypeName = 'Monthly AM GS';
		RecordTypeInfo recordTypeInfoObj = Schema.SObjectType.Sales_Performance_Monthly_AMGS__c.getRecordTypeInfosByName().get(recordTypeName);
		

		for (EDA__c edaObj : objList) {
			String years = string.valueOf(edaObj.EDA_Completion_Date__c.year());
			String yearf = years.right(2);
			String months = string.valueOf(edaObj.EDA_Completion_Date__c.MONTH());
			String Monthf = '0' + months;
			monthf = monthf.right(2);

			Sales_Performance_Monthly_AMGS__c sprObj =  new Sales_Performance_Monthly_AMGS__c(); 

			if (recordTypeInfoObj <> null) {
				Id recordTypeId = recordTypeInfoObj.getRecordTypeId();
				if (RecordTypeId<>null) sprObj.recordtypeid = recordTypeId; 
			}

			sprObj.Unique_ID__c = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' + 
					yearf + Monthf + '_' + 
					edaObj.AM_Employee_Id__c + '_'  + 
					edaObj.Group_Service_Name__c
					;

			sprObj.name = sprObj.Unique_ID__c;

			//--TODO : handling user NOT ACTIVE
			String ownerid = edaObj.ownerid; 
			sprObj.OwnerId = ownerid;
			sprObj.AM__c = ownerid;
			
			//-- set group service
			//system.debug('== edaObj.Group_Service__c : ' + edaObj.Group_Service__c);
			system.debug('== groupServiceMap : ' + groupServiceMap);
			sprObj.Group_Service__c = groupServiceMap.get(edaObj.Group_Service_Name__c.toUppercase());
			
			sprObj.Sales_Manager__c = edaObj.SM_SFID__c;
			sprObj.Group_Head__c = edaObj.GH_SFID__c;

			sprObj.Year__c = years;
			sprObj.Month__c = months;
			if (edaObj.EDA_Completion_Date__c <> null) {
				sprObj.Period_Date__c = edaObj.EDA_Completion_Date__c.addMonths(1);
			}
			else {
				sprObj.Period_Date__c = system.today().addMonths(1);
			}

			String sprUniqueID = sprMAMGSUniqueIDMAP.get(sprObj.Unique_ID__c);

			// kondisi jika blum ada di dalam map dan sebelum di masukan di list di check agar tidak duplicate
			if(sprUniqueID == null){
				salesPerformanceList.add(sprObj);
				sprUniqueIDMAP.put(sprObj.Unique_ID__c, sprObj.Unique_ID__c);
			}
			system.debug('============= salesPerformanceList waiving : '+ salesPerformanceList);
			system.debug('============= sprUniqueIDMAP waiving : '+  sprUniqueIDMAP);
		}

		system.debug('====== salesPerformanceList BEFORE UPSERT : ' + salesPerformanceList);	
		upsert salesPerformanceList Unique_ID__c;
		system.debug('====== salesPerformanceList AFTER UPSERT : ' + salesPerformanceList);	
		
		//-- add sales-performnce data into the return map
		for (Sales_Performance_Monthly_AMGS__c sprObj :  salesPerformanceList) {
			//-- put unique_id as the key, and salesPerformanceObj as the value
			salesPerformanceMap.put ( sprObj.Unique_ID__c, sprObj);
		}


		//-- return the map of Sales-Performance <unique_id, obj>
		return salesPerformanceMap;
	
	}
	*/
	
}