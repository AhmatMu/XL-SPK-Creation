/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-22-2022
 * @last modified by  : Diky Nurosid
**/
public class SalesRevenueTriggerHandler {
  
    private Boolean m_isExecuting = false;
    private Integer batchSize = 0;

    Static Final String SALES_PERFORMANCE_PREFIX_UNIQUEID = 'SPR';
	Static Final String SALES_TARGET_PREFIX_UNIQUEID = 'STR';
	Static Final String SALES_REVENUE_PREFIX_UNIQUEID = 'SRV';

    private Map<String, String> generalSettingMap = null;

    private string SPR_MONTHLY_AMGS_DEFAULT_SFID;
    private string SPR_MONTHLY_AM_DEFAULT_SFID;
    private string SPR_MONTHLY_DEFAULT_SFID;
    

    public SalesRevenueTriggerHandler(Boolean isExecuting, Integer size) {
        m_isExecuting = isExecuting;
        batchSize = size;

        /* old way ---
        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        */
        List<Sales_Performance_General__c> listSPGeneralSetting = Sales_Performance_General__c.getall().values();
        
        Map<String, String> generalSettingMap = new Map<String, String>();
        for (Sales_Performance_General__c  setting : listSPGeneralSetting) {
            generalSettingMap.put(setting.name, setting.value__c);

            switch on setting.name {
                when 'SPR_MONTHLY_AMGS_DEFAULT_SFID' {
                    SPR_MONTHLY_AMGS_DEFAULT_SFID = setting.value__c;
                }
                when 'SPR_MONTHLY_AM_DEFAULT_SFID' {
                    SPR_MONTHLY_AM_DEFAULT_SFID = setting.value__c;
                }
                when 'SPR_MONTHLY_DEFAULT_SFID' {
                    SPR_MONTHLY_DEFAULT_SFID = setting.value__c;
                }
            }
        } 
    }

    public void OnBeforeInsert(List<Sales_Revenue__c> newSalesRevenueList) {

        SYSTEM.DEBUG ('================== IN SalesrevuneTriggerHandler.OnBeforeInsert ========');
        
        /************************************** 
        * set some lookup fields 
        * owner / am 
        * Customer using BAP number
        * sales manager
        * group head
        * group service
        * revenue category 
        * msp id
        */

        boolean avoid = false;
        boolean doDeleteFirst = true;
		
        List<string> srvUniqueIDList = new List<string> ();
        
        Set<String> AMEmployeeIDS = new Set<String>();
        Set<String> SMEmployeeIDS = new Set<String>();
        Set<String> GHEmployeeIDS = new Set<String>();
        Set<String> userEmployeeIDS = new Set<String>();
        Set<String> customerBPNoS = new Set<String>(); 

        Set<String> groupServiceNames = new Set<String>();
        Set<String> revenueCategoryNames = new Set<String>();
        Set<String> segmentNames = new Set<String>();

        Set<String> salesPerformanceNames = new Set<String>();
		Set<String> salesPerformanceUniqueIDs = new Set<String>();

        string AMEmployeeID ;
        String SMEmployeeID ;
        String GHEmployeeID ;
        String userEmployeeID;
        string groupServiceName ;
        string revenueCategoryName ='';
        string BPNo ='';
        string sMonth;
        string sYear;
        Date periodDate;
		string sprM_AM_GS_UniqueID;
        string sprM_AM_UniqueID;
        string sprM_UniqueID;


        string sprUniqueIDTemp;
        string srvUniqueID;
        string suffixName;

        
        //-- 1. create parent first
        //-- create Sales-Performance Records and put the result into the map (to get the SFID)
        SalesPerformanceController salesPerformanceCtrl = new SalesPerformanceController();
        Map<String, String>  salesPerformanceMap = 
            salesPerformanceCtrl.createSalesPerformanceRecordsBasedOnSalesRevenues (newSalesRevenueList) ; 
        system.debug('========= salesPerformanceMap : '+ salesPerformanceMap);
        
        
        //-- 2. update some fields of Sales REVENUE Data
        for ( Sales_Revenue__C newSalesRevenueObj : newSalesRevenueList ) {
            if (newSalesRevenueObj.Revenue_Category_Name__c <> null && newSalesRevenueObj.Revenue_Category_Name__c <> '') {
                newSalesRevenueObj.Revenue_Category_Name__c =  newSalesRevenueObj.Revenue_Category_Name__c.replace('"', '');
            }
    
            if (newSalesRevenueObj.Group_service_name__c <> null && newSalesRevenueObj.Group_service_name__c <> '') {
                newSalesRevenueObj.Group_service_name__c = newSalesRevenueObj.Group_service_name__c.replace('"', '');
            }

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
            

			revenueCategoryNames.add ( newSalesRevenueObj.Revenue_Category_Name__c );
            groupServiceNames.add (newSalesRevenueObj.Group_service_name__c);
            //update handle only not null account
            if(newSalesRevenueObj.Customer_BP_No__c != null && newSalesRevenueObj.Customer_BP_No__c != ''){
                customerBPNoS.add (newSalesRevenueObj.Customer_BP_No__c);
            }
            SYSTEM.DEBUG (' == userEmployeeID : ' + userEmployeeID );
            SYSTEM.DEBUG (' == userEmployeeIDS : ' + userEmployeeIDS );
            SYSTEM.DEBUG ('======== groupServiceNames : ' + groupServiceNames );
            SYSTEM.DEBUG ('======== revenueCategoryNames : ' + revenueCategoryNames );
            SYSTEM.DEBUG ('======== salesPerformanceNames : ' + salesPerformanceNames );
            SYSTEM.DEBUG ('======== customerBPNoS : ' + customerBPNoS );
        }

		//-- GET Revenue Category data -----------------------------------------
        List<Revenue_Category__c> revenueCategoryList =  
                                [ SELECT ID, Name, Group_Service__c,  Group_Service__r.name, GRoup_service__r.type__c
                                    FROM Revenue_Category__c 
                                    WHERE Name in :revenueCategoryNames
        ];
        //-- PUT NAME and SFID into the Map
        Map<String, Revenue_Category__c> revenueCategoryMap = new Map<String, Revenue_Category__c>();
        for (Revenue_Category__c obj : revenueCategoryList) {
            revenueCategoryMap.put(obj.Name.toUpperCase(), obj);
        }

        /*
        //-- GET Group Services data -----------------------------------------
        List<Group_Service__c> groupServiceList =  
                                [ SELECT ID, Name, group_service_type__c 
                                    FROM Group_Service__c 
                                    WHERE Name in :groupServiceNames
        ];
        //-- PUT NAME and SFID into the Map
        Map<String, String> groupServiceMap = new Map<String, String>();
        for (Group_Service__c obj : groupServiceList) {
            groupServiceMap.put(obj.Name.toUpperCase(), obj.ID);
        }
        SYSTEM.DEBUG ('======== groupServiceMap : ' + groupServiceMap );
        */

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
        
        /*
        for ( Sales_Revenue__c newSalesRevenueObj : newSalesrevenueList ) {
            userEmployeeIDS.add ( newSalesRevenueObj.AM_Employee_ID__c );
            /*
            userEmployeeIDS.add ( newSalesRevenueObj.Sales_Manager_Employee_ID__c );
            userEmployeeIDS.add ( newSalesRevenueObj.Group_Head_Employee_ID__c );
            BAPcustomerIDS.add (newSalesRevenueObj.Customer__c);
 
            groupServiceNames.add ( newSalesRevenueObj.Group_Service__c );
            revenueCategoryNames.add ( newSalesRevenueObj.Revenue_Category__c );
            /////salesPerformanceNames.add ( newSalesTargetObj.Monthly_Sales_Performance_Name__c );
            */
            /*
            Revenue_Category__c revenueCategoryOBJ = revenueCategoryMap.get(newSalesRevenueObj.Revenue_Category_Name__c);
			
            string sprUniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
            newSalesRevenueObj.Year__c.right(2) + 
						('0' + newSalesRevenueObj.Month__c ).right(2) + '_' +
						newSalesRevenueObj.AM_Employee_ID__c + '_' +
						newSalesRevenueObj.Group_Service_Name__c;

            salesPerformanceUniqueIDs.add(sprUniqueID);            
        }
        */

        //-- GET data and put in to the map --------------------------


        //-- GET Users data -----------------------------------------
        List<User> userList =  new List<User>();
        if (userEmployeeIDS != null) {

            userList = [  SELECT ID, Employee_ID__c, userRole.Name, ManagerID, Manager.managerID, manager.userRole.name, manager.manager.UserRole.name 
                                FROM User 
                                WHERE Employee_ID__c in :userEmployeeIDS
            ];
            system.debug(' == userList :' + userList);
        }

        
        //-- PUT EmployeID and SFID into the Map
        //-- PUT EmployeID and SFID into the Map
        Map<String, User> userMap = new Map<String, User>();
        for (User obj : userList) {
            userMap.put(obj.Employee_ID__c, obj);
			system.debug(' ==userMap : ' + userMap);
			//put user role name as segment list
			string roleName = obj.userRole.Name;
            system.debug('=== roleName : **' + roleName + '**');
            if (roleName != null) {
                if (roleName <> null) {
			        roleName  = roleName.replace('Head - ', '').replace('Group Head - ', '');
                    system.debug('=== roleName : ##' + roleName + '##');
                    segmentNames.add (roleName);
                }
            }
        }

        SYSTEM.DEBUG ('======== userMap : ' + userMap );
		SYSTEM.DEBUG ('======== segmentNames : ' + segmentNames );

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

        //-- GET Account data -----------------------------------------
        //update handle account only bp dan not nul bp nonya
        Map<String, Account> ACCMap = new Map<String, Account>();
        System.debug('customerBPNoS.size.line272 ' +  customerBPNoS.size());
        if(customerBPNoS.size() > 0){
            Id AccountBPRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BP').getRecordTypeId();
            List<Account> ACCList =  
                                [ SELECT ID, BP_Number__c, type, Is_New_Customer__c  
                                    FROM Account 
                                    WHERE recordtypeid =: AccountBPRecordTypeId and BP_Number__c in :customerBPNoS
            ];

             //-- PUT BP customer Account and obbj into the Map
            for (Account obj : ACCList) {
                ACCMap.put(obj.BP_Number__c, obj);
                //system.debug('===== ACCMap' + ACCMap);
            }
        }
            

       
       

        //-- GET Sales Performance data -----------------------------------------
        /*
        List<Sales_Performance_Monthly_AMGS__c> salesPerformanceList =  
                                [ SELECT ID, Name 
                                    FROM Sales_Performance_Monthly_AMGS__c 
                                    WHERE Name in :salesPerformanceNames
        ];
        //-- PUT NAME and SFID into the Map
        Map<String, String> salesPerformanceMap = new Map<String, String>();
        
        
        for (Sales_Performance_Monthly_AMGS__c obj : salesPerformanceList) {
            salesPerformanceMap.put(obj.Name, obj.ID);
        }

        SYSTEM.DEBUG ('======== salesPerformanceMap : ' + salesPerformanceMap );
        */

        // get sales performance data

        /*
        List<Sales_Performance_Monthly_AMGS__c> salesPerformanceList =  
                                [ SELECT ID, Name 
                                    FROM Sales_Performance_Monthly_AMGS__c 
                                    WHERE Unique_ID__c in :salesPerformanceUniqueIDs
        ];
        //-- PUT NAME and SFID into the Map
        Map<String, String> salesPerformanceMap = new Map<String, String>();
        
        
        for (Sales_Performance_Monthly_AMGS__c obj : salesPerformanceList) {
            salesPerformanceMap.put(obj.Name, obj.ID);
        }
        SYSTEM.DEBUG ('======== salesPerformanceMap : ' + salesPerformanceMap );
        */



        //-- FILL DATA ------------------------------------------------------------------------------------
        for ( Sales_revenue__c newSalesRevenueObj : newSalesRevenueList ) {
			
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
                
                if (amObjs <> null) {
                    
                    newSalesRevenueObj.AM__c = amObjs.id ;
                    userEmployeeID = newSalesRevenueObj.AM_Employee_ID__c;
                    //-- set Sales Manager
                    system.debug(' == amobjs >> ' +amObjs);

                    if(amObjs.managerid != null && amObjs.UserRole != null ){
                        if(amObjs.manager.userRole.name.contains('Group Head')){
                            newSalesRevenueObj.Group_Head__c = amObjs.ManagerId;
                        }else if(amObjs.manager.userRole.name.contains('Head')){
                            newSalesRevenueObj.Sales_Manager__c = amObjs.ManagerId;
                            newSalesRevenueObj.Group_Head__c = amObjs.manager.managerid;
                        }
                    }
                    
                    
                   //-- Set Group Head
				  //  newSalesRevenueObj.Group_Head__c = amObjs.manager.managerid;
                    
                    //-- set Segment
                    
                    string roleName = amObjs.userRole.Name;
                    system.debug(' roleName :' +roleName);
                    if (roleName <> null) {
                        roleName  = roleName.replace('Head - ', '').replace('Group Head - ', '');
                    }
                    segment__c tmpSegementOBJ = segmentMap.get(roleName);
                    
                    if  (tmpSegementOBJ <> null ) {
                        newSalesRevenueObj.Segment__c = segmentMap.get(roleName).id;
                    }

                    system.debug(' newSalesRevenueObj = :' + newSalesRevenueObj.AM__c + '  | sales manager :  '+ newSalesRevenueObj.Sales_Manager__c + '| Group Head :+ ' + newSalesRevenueObj.group_head__c);
                }

                else if(newSalesRevenueObj.AM__c <> null){
                    system.debug('newSalesRevenueObj.AM__c == :' + newSalesRevenueObj.AM__c);
                    //-- set AM
                    AMEmployeeID = newSalesRevenueObj.AM_Rel_Employee_ID__c;
                    userEmployeeID = newSalesRevenueObj.AM_Rel_Employee_ID__c;

                    if(newSalesRevenueObj.Manager_Role_Name__c.contains('Group Head')){
                        newSalesRevenueObj.Group_Head__c = newSalesRevenueObj.AM_Rel_SM_SFID__c;  
                    }else if(newSalesRevenueObj.Manager_Role_Name__c.contains('Head')){
                        newSalesRevenueObj.Sales_Manager__c = newSalesRevenueObj.AM_Rel_SM_SFID__c;  
                        newSalesRevenueObj.Group_Head__c = newSalesRevenueObj.AM_Rel_GH_SFID__c;  
                    }

                    //-- set Segment
                    string roleName = newSalesRevenueObj.AM_Role_Name__c;
                    system.debug(' roleName :' +roleName);
                    if (roleName <> null) {
                        roleName  = roleName.replace('Head - ', '').replace('Group Head - ', '');
                    }
                    segment__c tmpSegementOBJ = segmentMap.get(roleName);
                        system.debug(' == :tmpSegementOBJ '+tmpSegementOBJ);                    
                    if  (tmpSegementOBJ <> null ) {
                        newSalesRevenueObj.Segment__c = segmentMap.get(roleName).id;
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
                    newSalesRevenueObj.Sales_Manager__c = smObjs.id ;
                
                   //-- Set Group Head
				    newSalesRevenueObj.Group_Head__c = smObjs.ManagerId;
                    //-- set Segment
                    
                    string roleName = smObjs.userRole.Name;
                    system.debug(' SM roleName : ' + roleName);
                    if (roleName <> null) {
                        roleName  = roleName.replace('Head - ', '').replace('Group Head - ', '');
                    }
                    system.debug(' SM roleName afterreplaces : ' + roleName);
                    segment__c tmpSegementOBJ = segmentMap.get(roleName);
                    
                    if  (tmpSegementOBJ <> null ) {
                        newSalesRevenueObj.Segment__c = segmentMap.get(roleName).id;
                    }
                }

               else if(newSalesRevenueObj.Sales_Manager__c <> null){
                    //-- set AM
                    SMEmployeeID = newSalesRevenueObj.SM_Rel_Employee_ID__c;
                    userEmployeeID = newSalesRevenueObj.SM_Rel_Employee_ID__c;
                    system.debug(' == SMEmployeeID : ' + SMEmployeeID);
                    //-- Set Group Head
				    newSalesRevenueObj.Group_Head__c = newSalesRevenueObj.SM_Rel_GH_SFID__c;
                    system.debug('== SM newSalesRevenueObj.Group_Head__c '+ newSalesRevenueObj.Group_Head__c);
                    //-- set Segment
                    Segment__c segmentOBJ = segmentMap.get(newSalesRevenueObj.SM_Rel_Segment__c);
                                        
                    if (segmentOBJ <> null) {
                        newSalesRevenueObj.Segment__c = segmentOBJ.id;
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
                        newSalesRevenueObj.Segment__c = segmentMap.get(roleName).id;
                    }
                }

              else if(newSalesRevenueObj.group_head__c <> null){
                    //-- set group head
                    GHEmployeeID = newSalesRevenueObj.GH_Rel_Employee_ID__c;
                    userEmployeeID = newSalesRevenueObj.GH_Rel_Employee_ID__c;
                    
                    //-- set Segment
                    Segment__c segmentOBJ = segmentMap.get(newSalesRevenueObj.GH_Rel_Segment__c);
                    if (segmentOBJ <> null) {
                        newSalesRevenueObj.Segment__c = segmentOBJ.id;
                    }
            }
        }
        
          /*  
            
			if (newSalesRevenueObj.AM__c == null) {
                //-- set AM
				amObjs = userMap.get(newSalesRevenueObj.AM_Employee_ID__c);
                AMEmployeeID = newSalesRevenueObj.AM_Employee_ID__c;
                if (amObjs <> null) {
                    newSalesRevenueObj.AM__c = amObjs.id ;
                    

                    //-- set Sales Manager
                    newSalesRevenueObj.Sales_Manager__c = newSalesRevenueObj.Sales_Manager__c;

                    //-- Set Group Head
                    newSalesRevenueObj.Group_Head__c = newSalesRevenueObj.group_head__c;
                    
                    //-- set Segment
                    string roleName = amObjs.userRole.Name;
                    if (roleName <> null) {
                        roleName  = roleName.replace('Head - ', '').replace('Group Head - ', '');
                    }
                    segment__c tmpSegementOBJ = segmentMap.get(roleName);
                    
                    if  (tmpSegementOBJ <> null ) {
                        newSalesRevenueObj.Segment__c = segmentMap.get(roleName).id;
                    }
                }

			}
            else if (newSalesRevenueObj.AM__c <> null ){
                //-- set AM
                AMEmployeeID = newSalesRevenueObj.AM_Rel_Employee_ID__c;
                
                //-- set Sales Manager
				newSalesRevenueObj.Sales_Manager__c = newSalesRevenueObj.AM_Rel_SM_SFID__c;
                
                //-- Set Group Head
				newSalesRevenueObj.Group_Head__c = newSalesRevenueObj.AM_Rel_GH_SFID__c;

                //-- set Segment
                Segment__c segmentOBJ = segmentMap.get(newSalesRevenueObj.AM_Rel_Segment__c);
                if (segmentOBJ <> null) {
    				newSalesRevenueObj.Segment__c = segmentOBJ.id;
                }
            }
*/


            //-- set Revenue Category & Group Service
            //string groupServiceName = '';
            
            Revenue_Category__c revenueCategoryOBJ = new Revenue_Category__c();

            //-- get group service name from lookup field 
            if (newSalesRevenueObj.Group_Service__c <> null ) {
                groupServiceName = newSalesRevenueObj.Group_Service_Rel_Name__c;
                system.debug ('== lihat value groupServiceName : ' + groupServiceName);

            }

            //-- get group service name from group service name field 
            if (newSalesRevenueObj.Group_Service_Name__c <> '' && newSalesRevenueObj.Group_Service_Name__c <> null ) {
                // set group service
                //newSalesRevenueObj.Group_Service__c = groupServiceMap.get( newSalesRevenueObj.Group_Service_Name__c.toUpperCase() );
                groupServiceName = newSalesRevenueObj.Group_Service_Name__c;

                Group_Service__c groupServiceOBJ = groupServiceMap.get(groupServiceName.toupperCase());
                if (groupServiceOBJ <> null) {
                    newSalesRevenueObj.Group_Service__c = groupServiceOBJ.id;
                    newSalesRevenueObj.Group_Service_Type__c = groupServiceOBJ.type__c;
                }

            }


            //-- get revenue category name from lookup field 
            if (newSalesRevenueObj.Revenue_Category__c <> null ) {
                revenueCategoryName = newSalesRevenueObj.Revenue_Category_Rel_Name__c;
            }

            //-- get revenue category name  and group service name from revenue category name field             
            if (newSalesRevenueObj.Revenue_Category_Name__c <> '' && newSalesRevenueObj.Revenue_Category_Name__c <> null) {
                revenueCategoryOBJ = revenueCategoryMap.get(newSalesRevenueObj.Revenue_Category_Name__c.toUpperCase());
                if ( revenueCategoryOBJ <> null ) {  

                    //-- set revenue cateegory id
                    newSalesRevenueObj.Revenue_Category__c = revenueCategoryOBJ.Id;
                    revenueCategoryName = revenueCategoryOBJ.name;

                    //-- set group service id
                    newSalesRevenueObj.Group_Service__c = revenueCategoryOBJ.Group_Service__c; 
                    newSalesRevenueObj.Group_Service_Type__c = revenueCategoryOBJ.GRoup_service__r.type__c;
                    groupServiceName = revenueCategoryOBJ.Group_Service__r.name;

                }
            }



            //-- get CUSTOMER
            if (newSalesRevenueObj.Customer_BP_No__c <> null && newSalesRevenueObj.Customer_BP_No__c <> '') {
                BPNo = newSalesRevenueObj.Customer_BP_No__c;
                Account accObj = ACCMap.get (BPNo);
                if (accObj <> null ) {
                    newSalesRevenueObj.Customer__c = accObj.id ;
                    newSalesRevenueObj.customer_type_t__c = accObj.type;
                    newSalesRevenueObj.is_new_customer_t__c = accObj.is_new_customer__c;
                }
            }
            



            /*
            string salesPerformanceUniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
            newSalesRevenueObj.Year__c.right(2) + 
						('0' + newSalesRevenueObj.Month__c ).right(2) + '_' +
                        AMEmployeeID + '_' +
                        groupServiceName ;
            */
            
            system.debug ('== newSalesRevenueObj.Month__c : ' + newSalesRevenueObj.Month__c);
            
            sYear = newSalesRevenueObj.Year__c.right(2);
            sMonth = ('0' + newSalesRevenueObj.Month__c ).right(2) ;
            periodDate = Date.NewInstance (integer.valueof (newSalesRevenueObj.Year__c), integer.valueOf(sMonth), 1 );
            newSalesRevenueObj.Month__c = newSalesRevenueObj.Month__c ;
            
            system.debug ('== sMonth : ' + sMonth);
            system.debug ('== newSalesRevenueObj.Month__c : ' + newSalesRevenueObj.Month__c);
            

            //-- set periode date
            newSalesRevenueObj.period_date__c = periodDate;

            

            suffixName = '';
            system.debug ('=== newSalesRevenueObj.Type__c : ' + newSalesRevenueObj.Type__c);

			Switch on (newSalesRevenueObj.Type__c) {
				When 'Actual Revenue' {
                    sprM_AM_GS_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                                sYear + sMonth + '_' +
                                userEmployeeID + '_' +
                                groupServiceName ;

                    sprM_AM_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                                sYear + sMonth + '_' +
                                userEmployeeID ;

                    suffixName = 'ActualRevenue';
					srvUniqueID = SALES_REVENUE_PREFIX_UNIQUEID + '_' + 
                         sYear + sMonth + '_' +
                         userEmployeeID  + '_' +
                        revenueCategoryName + '_' + 
                        BPNo + '_' + 
                        suffixName;

                    doDeleteFirst = true;
				}


				When 'Forecast Revenue Recurring' {
                    suffixName = '';
                    sprM_AM_GS_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                                sYear + sMonth + '_' +
                                userEmployeeID + '_' +
                                groupServiceName ;  

                    sprM_AM_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                                sYear + sMonth + '_' +
                                userEmployeeID ;
                               
                    suffixName = 'FcsRevRec';
					srvUniqueID = SALES_REVENUE_PREFIX_UNIQUEID + '_' + 
                         sYear + sMonth + '_' +
                         userEmployeeID  + '_' +
                        revenueCategoryName + '_' + 
                        BPNo + '_' + 
                        suffixName;

                    doDeleteFirst = true;
				}                



                When 'Actual Revenue M-Ads Enterprise', 'Actual Revenue M-Ads ADAI' {
                    sprM_AM_GS_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                                sYear + sMonth ;    //-- todo : remove it

                    sprM_UniqueID  = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                                sYear + sMonth ;

                    srvUniqueID = SALES_REVENUE_PREFIX_UNIQUEID + '_' + 
                                sYear + sMonth + '_' +
                               newSalesRevenueObj.Type__c.replace(' ','');
                
                    doDeleteFirst = true;
                }                


                When 'Subscribe Churn', 'Subscribe Gross Add' {
                    sprM_AM_GS_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                            sYear + sMonth + '_' +
                            userEmployeeID ;              //-- todo : remove it

                    sprM_AM_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                            sYear + sMonth + '_' +
                            userEmployeeID ;

                    suffixName = newSalesRevenueObj.Type__c.replace(' ','');
					srvUniqueID = SALES_REVENUE_PREFIX_UNIQUEID + '_' + 
                        newSalesRevenueObj.Year__c.right(2) + 
						('0' + newSalesRevenueObj.Month__c ).right(2) + '_' +
						//newSalesRevenueObj.AM_Employee_ID__c + '_' + 
                        userEmployeeID  + '_' +
                        newSalesRevenueObj.Subscription_type__c  + '_' +
                        newSalesRevenueObj.Service__c  + '_' +
                        newSalesRevenueObj.GROUP_PRICE_PLAN__c  + '_' +
                        BPNo  + '_' +
                        suffixName;

                    doDeleteFirst = true;
				}

                When 'Link Churn', 'Link Gross Add' {
                    sprM_AM_GS_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                            sYear + sMonth + '_' +
                            userEmployeeID ;          //-- todo : remove it

                    sprM_AM_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                            sYear + sMonth + '_' +
                            userEmployeeID ;
                      
                    /* sudah diset di sales revenue controller 
                    suffixName = newSalesRevenueObj.Type__c.replace(' ','');
					srvUniqueID = SALES_REVENUE_PREFIX_UNIQUEID + '_' + 
                        newSalesRevenueObj.Year__c.right(2) + 
						('0' + newSalesRevenueObj.Month__c ).right(2) + '_' +
						.... ; */
                    
                    doDeleteFirst = false;
				}                

                When 'Forecast Waiving', 'Forecast Revenue Pending Recurring' {
                    sprM_AM_GS_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                                sYear + sMonth + '_' +
                                userEmployeeID.replace('{', '').replace('}', '') + '_' +
                                groupServiceName   ;

                    sprM_AM_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                                sYear + sMonth + '_' +
                                userEmployeeID ;

                    doDeleteFirst = false;
                }


                when 'Opportunity Product' {

                    sprM_AM_GS_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                        sYear + sMonth + '_' +
                        userEmployeeID  + '_' +
                        groupServiceName  
                        ;
                    system.debug(' sprM_AM_GS_UniqueID :' + sprM_AM_GS_UniqueID);
                        
                    sprM_AM_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                        sYear + sMonth + '_' +
                    userEmployeeID ;
                    System.debug('sprM_AM_UniqueID :' + sprM_AM_UniqueID);
                    doDeleteFirst = false;
                }

                /*
                when 'Opportunity Product Monthly-AMGS' {
                    
                    sprM_AM_GS_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                        sYear + sMonth + '_' +
                        AMEmployeeID  + '_' +
                        groupServiceName  
                        ;
                        
                    sprM_AM_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                        sYear + sMonth + '_' +
                        AMEmployeeID ;
                
                    doDeleteFirst = false;
                }
                when 'Opportunity Product Monthly-AM' {
                    
                    sprM_AM_GS_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                        sYear + sMonth + '_' +
                        AMEmployeeID ;

                    sprM_AM_UniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                        sYear + sMonth + '_' +
                        AMEmployeeID ;

                    doDeleteFirst = false;
                }
                */
        }
    
            

            /*
            newSalesRevenueObj.Sales_Performance_Monthly_AMGS__c = salesPerformanceMap.get(salesPerformanceUniqueID);
            newSalesRevenueObj.Sales_Performance_Monthly_AMGS_SFID__c = salesPerformanceMap.get(salesPerformanceUniqueID);
            system.System.debug('============== salesPerformanceUniqueID : ' + salesPerformanceUniqueID);
            */

            System.debug ('=== salesPerformanceMap : ' + salesPerformanceMap);
            System.debug ('=== sprM_AM_GS_UniqueID : ' + sprM_AM_GS_UniqueID);
            
            /*Sales_Performance_Monthly_AMGS__c sprTMPOBJ = salesPerformanceMap.get(sprUniqueID);
            System.debug ('=== sprTMPOBJ : ' + sprTMPOBJ);*/

            ID sprMAMGSID = salesPerformanceMap.get(sprM_AM_GS_UniqueID + 'MAMGS');
            ID sprMAMID = salesPerformanceMap.get(sprM_AM_UniqueID + 'MAM');
            System.debug ('=== sprMAMGSID : ' + sprMAMGSID);
            System.debug ('=== sprMAMID : ' + sprMAMID);
            
            /*
            if (sprTMPOBJ <> null) {
                newSalesRevenueObj.Sales_Performance_Monthly_AMGS__c = sprTMPOBJ.id;
                newSalesRevenueObj.Sales_Performance_Monthly_AMGS_SFID__c = sprTMPOBJ.id;
            } else {
                newSalesRevenueObj.Sales_Performance_Monthly_AMGS__c = 'a1AN0000002fmxy';         //-- TODO: set to custom label / setting;
                newSalesRevenueObj.Sales_Performance_Monthly_AMGS_SFID__c = 'a1AN0000002fmxy';    //-- TODO: set to custom label / setting
            }
            */


            if (sprMAMGSID <> null) {
                system.debug('== in sprMAMGSID <> null');
                newSalesRevenueObj.Sales_Performance_Monthly_AMGS__c = sprMAMGSID;
                newSalesRevenueObj.Sales_Performance_Monthly_AMGS_SFID__c = sprMAMGSID;
            } else {
                system.debug('== in else sprMAMGSID <> null');
                newSalesRevenueObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID;  //'a1AN0000002fmxy';         //-- TODO: set to custom label / setting;
                newSalesRevenueObj.Sales_Performance_Monthly_AMGS_SFID__c = SPR_MONTHLY_AMGS_DEFAULT_SFID;    //-- TODO: set to custom label / setting
                system.debug(' >> newSalesRevenueObj.Sales_Performance_Monthly_AMGS__c :' + newSalesRevenueObj.Sales_Performance_Monthly_AMGS__c);
                system.debug(' >> newSalesRevenueObj.Sales_Performance_Monthly_AMGS_SFID__c :' + newSalesRevenueObj.Sales_Performance_Monthly_AMGS_SFID__c);
                
            }   

            if (sprMAMID <> null) {
                newSalesRevenueObj.Sales_Performance_Monthly_AM__c = sprMAMID;
                newSalesRevenueObj.Sales_Performance_Monthly_AM_SFID__c = sprMAMID;
            } else {
                newSalesRevenueObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID;         //-- TODO: set to custom label / setting;
                newSalesRevenueObj.Sales_Performance_Monthly_AM_SFID__c = SPR_MONTHLY_AM_DEFAULT_SFID;    //-- TODO: set to custom label / setting
            }



            //-- set sales revenue unique id 
			System.debug ('=== srvUniqueID : ' + srvUniqueID);
			if (srvUniqueID <> null) {
				newSalesRevenueObj.Unique_ID__c = srvUniqueID;
				if ( srvUniqueID.length() > 80) newSalesRevenueObj.Name = srvUniqueID.left(75) + ' ...';
					else newSalesRevenueObj.Name = srvUniqueID;
			}

            //-- SET Record Type by TYPE
            /*Map <String, RecordType> recordTypeMap = new Map <String, RecordType>();
			RecordType strRecordTypeOBJ = recordTypeMap.get(newSalesRevenueObj.Type__c);
			if (strRecordTypeOBJ != null) newSalesRevenueObj.RecordTypeId = strRecordTypeOBJ.id;
            */

            Id RecordTypeId = Schema.SObjectType.Sales_Revenue__c.getRecordTypeInfosByName().get(newSalesRevenueObj.type__c).getRecordTypeId();
            if (RecordTypeId<>null) newSalesRevenueObj.recordtypeid = RecordTypeId;


            srvUniqueIDList.add (srvUniqueID);
            system.debug ('=== newSalesRevenueObj.amount__c : ' + newSalesRevenueObj.amount__c);
            system.debug ('== srvUniqueIDList.size() : ' + srvUniqueIDList.size());
            system.debug ('== srvUniqueIDList ' + srvUniqueIDList);
        }

        if (doDeleteFirst && srvUniqueIDList.size()>0) {
            //-- delete first
            List<Sales_Revenue__c> srvTobeDeleteList = [select id , unique_id__c from Sales_Revenue__c where unique_id__c in : srvUniqueIDList];
            system.debug('== srvTobeDeleteList : ' + srvTobeDeleteList);
            if (srvTobeDeleteList.size() >0) {
                //delete strTobeDeleteList;

                for (Sales_Revenue__c srvTobeDelete : srvTobeDeleteList) {
                    srvTobeDelete.unique_id__c = srvTobeDelete.unique_id__c + ' TOBEDELETE';
                    srvTobeDelete.isTobeDelete__c = TRUE;   //-- new way, Dec 2, 2021 by Doddy
                }
                update srvTobeDeleteList;
            }
        }
    }

    


    public void OnAfterInsert(List<Sales_Revenue__c> newSalesRevenueList) {
        List<ID> IDs= new List<ID> ();
		for (Sales_Revenue__c strOBJ : newSalesRevenueList) {
			IDs.add(strOBJ.id);
		}
        system.debug('== IDs.newSalesrevenueList == : ' + IDs);
		List<Sales_Revenue__c> tmpSalesRevenueList = [select id , Sales_Performance_Monthly_AMGS__c, 
                                                            Sales_Performance_Monthly_AMGS_SFID__c 
                                                        from Sales_Revenue__c 
                                                        where id in :IDs ];
                                                        
		for (Sales_Revenue__c strOBJ : tmpSalesRevenueList) {
            
            System.debug ('=== tmpSalesRevenueList.SPRMAMGS : ' + strOBJ.Sales_Performance_Monthly_AMGS__c);
			strOBJ.Sales_Performance_Monthly_AMGS__c = strOBJ.Sales_Performance_Monthly_AMGS_SFID__c;
            System.debug ('=== tmpSalesRevenueList.SPRMAGSSFID : ' + strOBJ.Sales_Performance_Monthly_AMGS_SFID__c);
            System.debug ('=== tmpSalesRevenueList : ' + tmpSalesRevenueList);
		}

		
		update tmpSalesRevenueList;


        //-- delete the previous data 
        //--old way : List<Sales_Revenue__c> srvTobeDeleteList = [select id from Sales_Revenue__c where unique_id__c like '%TOBEDELETE'];
        List<Sales_Revenue__c> srvTobeDeleteList = [select id from Sales_Revenue__c where isTobeDelete__c = TRUE  AND CreatedDate = TODAY limit 200000];          //-- new way, Dec 2, 2021 by Doddy
        
        if (srvTobeDeleteList.size() >0) {
            delete srvTobeDeleteList;
        }
    }


    @Future public static void OnAfterInsertAsync(Set<Id> newSalesRevenueIDs) {
    }
//system.debug('=====================newSalesRevenueIDs'+ newSalesRevenueIDs);
    public void OnBeforeUpdate(List<Sales_Revenue__c> oldSalesRevenueList, List<Sales_Revenue__c> updatedSalesRevenueList, Map<Id, Sales_Revenue__c> oldSalesRevenueMap, Map<Id, Sales_Revenue__c> newSalesRevenueMap) {
    }

    public void OnAfterUpdate(List<Sales_Revenue__c> oldSalesRevenueList, List<Sales_Revenue__c> updatedSalesRevenueList, Map<Id, Sales_Revenue__c> oldSalesRevenueMap, Map<Id, Sales_Revenue__c> newSalesRevenueMap) {

    }

    @Future public static void OnAfterUpdateAsync(Set<Id> updatedSalesRevenueIDs) {
    }

    public void OnBeforeDelete(List<Sales_Revenue__c> salesRevenueListToDelete, Map<Id, Sales_Revenue__c> salesRevnenuMap) {

        System.debug ('=== before delete ==== ');
        System.debug ('=== salesRevenueListToDelete : ' + salesRevenueListToDelete);
        

    }

    public void OnAfterDelete(List<Sales_Revenue__c> deletedSalesRevenueList, Map<Id, Sales_Revenue__c> salesRevnenuMap) {

    }

    @Future public static void OnAfterDeleteAsync(Set<Id> deletedSalesTargetIDs) {

    }

    public void OnUndelete(List<Sales_Revenue__c> restoredSalesRevenueList) {

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