//salestarget 20220519
public with sharing class SalesTargetTriggerHandler {
   
    private Boolean m_isExecuting = false;
    private Integer batchSize = 0;

    Static Final String SALES_PERFORMANCE_PREFIX_UNIQUEID = 'SPR';
    Static Final String SALES_TARGET_PREFIX_UNIQUEID = 'STR';
    Static Final String SALES_REVENUE_PREFIX_UNIQUEID = 'SRV';

    private String SPR_MONTHLY_AMGS_DEFAULT_SFID = null;
    private String SPR_MONTHLY_AM_DEFAULT_SFID = null;
    private String SPR_MONTHLY_DEFAULT_SFID = null;


    public SalesTargetTriggerHandler(Boolean isExecuting, Integer size) {
        m_isExecuting = isExecuting;
        batchSize = size;

        List<Sales_Performance_General__c> listSPGeneralSetting = [select id, name, value__c, format__c 
                                                                from Sales_Performance_General__c
                                                                where name like 'SPR_MONTHLY_%'
                                                                ]; 
        
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

    public void OnBeforeInsert(List<Sales_Target__c> newSalesTargetList) {

        SYSTEM.DEBUG ('================== IN SalesTargetTriggerHandler.OnBeforeInsert ========');
        SYSTEM.DEBUG ('================== newSalesTargetList : ' + newSalesTargetList);
        SYSTEM.DEBUG ('================== newSalesTargetList.size() : ' + newSalesTargetList.size());
        
        /************************************** 
        * set some lookup fields 
        * owner / am 
        * sales manager
        * group head
        * group service
        * revenue category 
        * msp id
        */

        List<string> strUniqueIDList = new List<string> ();

        Set<String> AMEmployeeIDS = new Set<String>();
        Set<String> SMEmployeeIDS = new Set<String>();
        Set<String> GHEmployeeIDS = new Set<String>();
        Set<String> userEmployeeIDS = new Set<String>();

        Set<String> groupServiceNames = new Set<String>();
        Set<String> revenueCategoryNames = new Set<String>();
        Set<String> segmentNames = new Set<String>();

        Set<String> salesPerformanceNames = new Set<String>();
        Set<String> salesPerformanceUniqueIDs = new Set<String>();


        string AMEmployeeID ;
        string SMEmployeeID ;
        string GHEmployeeID ;
        string userEmployeeID;
        string groupServiceName ;
        string sMonth;
        string sYear;
        Date periodDate;
        string sprUniqueID;
        string strUniqueID;
        string suffixName;


        //-- 1. create parent first
        //-- create Sales-Performance Records and put the result into the map (to get the SFID)
        SalesPerformanceController salesPerformanceCtrl = new SalesPerformanceController();
        /*
        Map<String, Sales_Performance_Monthly_AMGS__c>  salesPerformanceMap = 
            salesPerformanceCtrl.createSalesPerformanceRecordsBasedOnSalesTargets (newSalesTargetList) ;
            */

        Map<String, String>  salesPerformanceMap = 
            salesPerformanceCtrl.createSalesPerformanceRecordsBasedOnSalesTargets (newSalesTargetList) ;
            
            
        system.debug('========= salesPerformanceMap : '+ salesPerformanceMap);



        //-- 2. update some fields of Sales Target Data
        
        for ( Sales_Target__c newSalesTargetObj : newSalesTargetList ) {
            //revenueCategoryNames.add ( newSalesTargetObj.Revenue_Category_Name__c );
            if (newSalesTargetObj.Group_service_name__c <> null && newSalesTargetObj.Group_service_name__c <> '') {
                newSalesTargetObj.Group_service_name__c = newSalesTargetObj.Group_service_name__c.replace('"', '');
            }

            groupServiceNames.add ( newSalesTargetObj.Group_Service_Name__c );

            if(newSalesTargetObj.AM_Employee_ID__c != null){
                userEmployeeID = newSalesTargetObj.AM_Employee_ID__c;
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
            groupServiceMap.put(obj.Name.toupperCase(), obj);
        }
        SYSTEM.DEBUG ('======== groupServiceMap : ' + groupServiceMap );
        //-------------------------------------------------------------------------------------

        SYSTEM.DEBUG ('======== userEmployeeIDS : ' + userEmployeeIDS );
        //-- GET Users data -----------------------------------------
        List<User> userList =  
        [ SELECT ID, Employee_ID__c, userRole.Name, ManagerID, Manager.managerID, manager.employee_id__c, manager.manager.employee_id__c, manager.userRole.name, manager.manager.UserRole.name FROM User WHERE Employee_ID__c in :userEmployeeIDS
        ];

        SYSTEM.DEBUG ('======== userEmployeeIDS : ' + userEmployeeIDS );

        //-- PUT EmployeID and SFID into the Map
        Map<String, User> userMap = new Map<String, User>();
        for (User obj : userList) {
            userMap.put(obj.Employee_ID__c, obj);

            //put user role name as segment list
            string roleName = obj.userRole.Name;
            if (roleName <> null) {
                roleName  = roleName.replace('Head - ', '').replace('Group Head - ', '');
                segmentNames.add (roleName);
            } else {
                system.debug ('== no role name > obj : ' + obj);
                system.debug ('== no role name > Employee_ID__c : ' + obj.Employee_ID__c);
                system.debug ('== no role name > name : ' + obj.name);

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

        SYSTEM.DEBUG ('======== userEmployeeIDS : ' + userEmployeeIDS );
        SYSTEM.DEBUG ('======== groupServiceNames : ' + groupServiceNames );


        //-- UPDATE EACH DATA IN SALES TARGET 
        for ( Sales_Target__c newSalesTargetObj : newSalesTargetList ) {
            User amObj = new User();
            User smObj = new User();
            User ghObj = new User();
            system.debug(' newSalesTargetObj.AM_Employee_ID__c ==' +newSalesTargetObj.AM_Employee_ID__c);
            system.debug(' newSalesTargetObj.AM__c == ' +newSalesTargetObj.AM__c);
            system.debug(' newSalesTargetObj.Sales_Manager_Employee_ID__c == ' + newSalesTargetObj.Sales_Manager_Employee_ID__c);
            system.debug(' newSalesTargetObj.Sales_Manager__c == ' +newSalesTargetObj.Sales_Manager__c);
            system.debug(' newSalesTargetObj.Group_Head__c ==' + newSalesTargetObj.Group_Head__c);
            system.debug(' newSalesTargetObj.Group_Head_Employee_ID__c == ' +newSalesTargetObj.Group_Head_Employee_ID__c);

            if(newSalesTargetObj.AM__c <> null || (newSalesTargetObj.AM_Employee_ID__c <> null && newSalesTargetObj.AM_Employee_ID__c <> '')){
                system.debug('in AM == ');
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
                    
                        //-- set Sales Manager
                        if(amObj.manager.userRole.name.contains('Group Head')){
                            newSalesTargetObj.Group_Head_Employee_ID__c = amObj.manager.manager.employee_id__c;
                            newSalesTargetObj.Group_Head__c = amObj.ManagerId;
                            
                        }else if(amObj.manager.userRole.name.contains('Head')){
                            newSalesTargetObj.Sales_Manager__c = amObj.ManagerId;
                            newSalesTargetObj.Sales_Manager_Employee_ID__c = amObj.manager.employee_id__c;
                            newSalesTargetObj.Group_Head__c = amObj.Manager.ManagerId;
                        }
                                           
                        //-- set Segment
                        if (amObj.userRole <> null) {
                            string roleName = amObj.userRole.Name;
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

            else if(newSalesTargetObj.Sales_Manager__c <> null || (newSalesTargetObj.Sales_Manager_Employee_ID__c <> null && newSalesTargetObj.Sales_Manager_Employee_ID__c <> '')){
                
                if (newSalesTargetObj.Sales_Manager_Employee_ID__c <> '' || newSalesTargetObj.Sales_Manager_Employee_ID__c <> null) {
                    SMEmployeeID =  newSalesTargetObj.Sales_Manager_Employee_ID__c;
                    userEmployeeID = newSalesTargetObj.Sales_Manager_Employee_ID__c;
                }
    
                if (newSalesTargetObj.Sales_Manager__c <> null) {
                    SMEmployeeID = newSalesTargetObj.Sales_Manager_Employee_ID__c;
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
                    GHEmployeeID = newSalesTargetObj.GH_Rel_Employee_ID__c;
                    userEmployeeID = newSalesTargetObj.GH_Rel_Employee_ID__c;
                }

                if (newSalesTargetObj.Group_Head__c == null) {
                    ghObj = userMap.get(GHEmployeeID);

                    if (ghObj <> null) {
                        newSalesTargetObj.Group_Head__c = ghObj.id ;
    
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

            //-- set GRoup SERVICE-----------------------------------------------------------------
            if (newSalesTargetObj.Group_Service_Name__c <> '') {
                groupServiceName =  newSalesTargetObj.Group_Service_Name__c;
            }
            if (newSalesTargetObj.Group_Service__c <> null) {
                groupServiceName = newSalesTargetObj.Group_Service_Rel_Name__c;
            }


            sYear = newSalesTargetObj.Year__c.right(2);
            sMonth = ('0' + newSalesTargetObj.Month__c ).right(2) ;
            periodDate = Date.NewInstance (integer.valueof (newSalesTargetObj.Year__c), integer.valueOf(sMonth), 1 );
            newSalesTargetObj.Month__c = newSalesTargetObj.Month__c;

            //-- set periode date
            newSalesTargetObj.period_date__c = periodDate;

            //-- set group service




            /*
            string salesPerformanceUniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                        newSalesTargetObj.Year__c.right(2) + 
                        ('0' + newSalesTargetObj.Month__c ).right(2) + '_' +
                        newSalesTargetObj.AM_Employee_ID__c + '_' +
                        newSalesTargetObj.Group_Service_Name__c;

            newSalesTargetObj.Sales_Performance_Monthly_AMGS__c = salesPerformanceMap.get(salesPerformanceUniqueID);
            newSalesTargetObj.Sales_Performance_Monthly_AMGS_SFID__c = salesPerformanceMap.get(salesPerformanceUniqueID);
            system.System.debug('============== salesPerformanceUniqueID' + salesPerformanceUniqueID);
            */
            
            suffixName = newSalesTargetObj.type__c.replace('Target ','').replace(' ','');
            switch on (newSalesTargetObj.type__c) {
                when 'Target Revenue' {
                    sprUniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                        sYear + sMonth + '_' +
                        userEmployeeID + '_' +
                        groupServiceName 
                        //+ '_'+ suffixName
                        ;
                    
                    strUniqueID = SALES_TARGET_PREFIX_UNIQUEID + '_' + 
                        sYear + sMonth + '_' +
                        userEmployeeID + '_' +
                        groupServiceName + '_' + 
                        suffixName
                        ;

                    if (groupServiceName <> null ) {    
                        Group_Service__c groupServiceOBJ = groupServiceMap.get(groupServiceName.toUpperCase());
                        if (groupServiceOBJ <> null) {
                            newSalesTargetObj.Group_Service__c = groupServiceOBJ.id;
                            newSalesTargetObj.Group_Service_Type__c = groupServiceOBJ.type__c;
                        }
                    }
                    
                }
                when 'Target Revenue (Partnership)' , 'Target Partnership Number' {
                    sprUniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                        sYear + sMonth + '_' +
                        userEmployeeID
                        ;
                    
                    strUniqueID = SALES_TARGET_PREFIX_UNIQUEID + '_' + 
                        sYear + sMonth + '_' +
                        userEmployeeID + '_' +
                        suffixName
                        ;

                    if (groupServiceName <> null ) {    
                        Group_Service__c groupServiceOBJ = groupServiceMap.get(groupServiceName.toUpperCase());
                        if (groupServiceOBJ <> null) {
                            newSalesTargetObj.Group_Service__c = groupServiceOBJ.id;
                            newSalesTargetObj.Group_Service_Type__c = groupServiceOBJ.type__c;
                        }
                    }
                    
                }
                when 'Target Add Link', 'Target Pipeline', 'Target Pipeline PO',
                        'Target Pipeline New Revenue', 'Target Pipeline BAU'
                {
                    sprUniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                        sYear + sMonth + '_' +
                        userEmployeeID 
                        //+ '_' +suffixName
                        ;

                    strUniqueID = SALES_TARGET_PREFIX_UNIQUEID + '_' + 
                        sYear + sMonth + '_' +
                        userEmployeeID + '_' + 
                        suffixName;
                }
                when 'Target Add Subscribe' {
                    sprUniqueID = SALES_PERFORMANCE_PREFIX_UNIQUEID + '_' +
                        sYear + sMonth + '_' +
                        userEmployeeID 
                        //+ '_' + suffixName
                        ;

                    strUniqueID = SALES_TARGET_PREFIX_UNIQUEID + '_' + 
                        sYear + sMonth + '_' +
                        userEmployeeID + '_' + 
                        newSalesTargetObj.subscription_type__c + '_' +
                        suffixName;
                }

            }

            System.debug ('=== salesPerformanceMap : ' + salesPerformanceMap);
            System.debug ('=== sprUniqueID : ' + sprUniqueID);
            //Sales_Performance_Monthly_AMGS__c sprTMPOBJ = salesPerformanceMap.get(sprUniqueID);
            ID sprMAMGSID = salesPerformanceMap.get(sprUniqueID + 'MAMGS');
            ID sprMAMID = salesPerformanceMap.get(sprUniqueID + 'MAM');
            
            System.debug ('=== sprMAMGSID : ' + sprMAMGSID);
            System.debug ('=== sprMAMID : ' + sprMAMID);

            if ( newSalesTargetObj.type__c == 'Target Revenue') {
                
                if (sprMAMGSID <> null) {
                    newSalesTargetObj.Sales_Performance_Monthly_AMGS__c = sprMAMGSID;
                    newSalesTargetObj.Sales_Performance_Monthly_AMGS_SFID__c = sprMAMGSID;
                    
                } else {
                    newSalesTargetObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID; //'a1AN0000002fmxy';         
                    newSalesTargetObj.Sales_Performance_Monthly_AMGS_SFID__c = SPR_MONTHLY_AMGS_DEFAULT_SFID; //'a1AN0000002fmxy';    

                }

                if (sprMAMID <> null) {
                    newSalesTargetObj.Sales_Performance_Monthly_AM__c = sprMAMID;
                    newSalesTargetObj.Sales_Performance_Monthly_AM_SFID__c = sprMAMID;

                } else {
                    newSalesTargetObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID; //'a1KN0000001lIetMAE';         
                    newSalesTargetObj.Sales_Performance_Monthly_AM_SFID__c = SPR_MONTHLY_AM_DEFAULT_SFID; //'a1KN0000001lIetMAE';    
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
                
                if (sprMAMID <> null) {
                    newSalesTargetObj.Sales_Performance_Monthly_AM__c = sprMAMID;
                    newSalesTargetObj.Sales_Performance_Monthly_AM_SFID__c = sprMAMID;

                } else {
                    newSalesTargetObj.Sales_Performance_Monthly_AM__c = SPR_MONTHLY_AM_DEFAULT_SFID; //'a1KN0000001lIetMAE';         
                    newSalesTargetObj.Sales_Performance_Monthly_AM_SFID__c = SPR_MONTHLY_AM_DEFAULT_SFID; //'a1KN0000001lIetMAE';    
                }

                newSalesTargetObj.Sales_Performance_Monthly_AMGS__c = SPR_MONTHLY_AMGS_DEFAULT_SFID; //'a1AN0000002fmxy';         ;
                newSalesTargetObj.Sales_Performance_Monthly_AMGS_SFID__c = SPR_MONTHLY_AMGS_DEFAULT_SFID;  // 'a1AN0000002fmxy';    

            }

            
            

            System.debug ('=== strUniqueID : ' + strUniqueID);
            if (strUniqueID <> null) {
                newSalesTargetObj.Unique_ID__c = strUniqueID;
                if ( strUniqueID.length() > 80) {
                    newSalesTargetObj.Name = strUniqueID.left(75) + ' ...';
                }else {
                    newSalesTargetObj.Name = strUniqueID;
                }           
            }

            //-- SET Record Type by TYPE
            String recordTypeName = newSalesTargetObj.type__c;
            RecordTypeInfo recordTypeInfoObj = Schema.SObjectType.Sales_Target__c.getRecordTypeInfosByName().get(recordTypeName);
            if (recordTypeInfoObj <> null) {
                Id recordTypeId = recordTypeInfoObj.getRecordTypeId();
                if (RecordTypeId<>null) newSalesTargetObj.recordtypeid = recordTypeId; 
            }

            //-- set NAME and Unique ID of Sales Target
            /*
            Add Link    Upload  STR [YY]    [MM]    [EMP_NO]    AddLink                 STR_2101_90004036_AddLink
            Add Subscribe   Upload  STR [YY]    [MM]    [EMP_NO]    AddSub                  STR_2101_90004036_AddSub
            New Revenue Upload  STR [YY]    [MM]    [EMP_NO]    NewRevenue                  STR_2101_90004036_NewRevenue
            Pipeline    Upload  STR [YY]    [MM]    [EMP_NO]    [REV_CAT]   Pipeline                STR_2101_90004036_VOIP_Pipeline
            Pipeline PO Upload  STR [YY]    [MM]    [EMP_NO]    [REV_CAT]   PipelinePO              STR_2101_90004036_VOIP_PipelinePO
            Revenue Upload  STR [YY]    [MM]    [EMP_NO]    [REV_CAT]   Revenue             STR_2101_90004036_VOIP_Revenue
            */

            /*
            Map <String, RecordType> recordTypeMap = new Map <String, RecordType>();
            RecordType strRecordTypeOBJ = recordTypeMap.get(newSalesTargetObj.Type__c);
            if (strRecordTypeOBJ != null) newSalesTargetObj.RecordTypeId = strRecordTypeOBJ.id;
            */

            
            strUniqueIDList.add (strUniqueID);

        }

        //-- delete first
        List<sales_target__c> strTobeDeleteList = [select id , unique_id__c from sales_target__c where unique_id__c in : strUniqueIDList];
        if (strTobeDeleteList.size() >0) {
            //delete strTobeDeleteList;

            for (sales_target__c strTobeDelete : strTobeDeleteList) {
                strTobeDelete.unique_id__c = strTobeDelete.unique_id__c + ' TOBEDELETE';
            }
            update strTobeDeleteList;
        }
 

    }

    public void OnAfterInsert(List<Sales_Target__c> newSalesTargetList) {
        
        List<ID> IDs= new List<ID> ();
        for (Sales_Target__c strOBJ : newSalesTargetList) {
            IDs.add(strOBJ.id);
        }

        List<Sales_Target__c> tmpSalesTargetList = [select id , Sales_Performance_Monthly_AMGS__c, 
                                                            Sales_Performance_Monthly_AMGS_SFID__c,
                                                            Sales_Performance_Monthly_AM__c, 
                                                            Sales_Performance_Monthly_AM_SFID__c
                                                        from Sales_Target__c 
                                                        where id in :IDs ];

        for (Sales_Target__c strOBJ : tmpSalesTargetList) {
            strOBJ.Sales_Performance_Monthly_AMGS__c = strOBJ.Sales_Performance_Monthly_AMGS_SFID__c;
            strOBJ.Sales_Performance_Monthly_AM__c = strOBJ.Sales_Performance_Monthly_AM_SFID__c;
            
        }

        System.debug ('=== tmpSalesTargetList : ' + tmpSalesTargetList);
        update tmpSalesTargetList;


        //-- delete the previous data 
        List<sales_target__c> strTobeDeleteList = [select id from sales_target__c where unique_id__c like '%TOBEDELETE'];
        if (strTobeDeleteList.size() >0) {
            delete strTobeDeleteList;
        }

    }

    @Future public static void OnAfterInsertAsync(Set<Id> newSalesTargetIDs) {
    }

    public void OnBeforeUpdate(List<Sales_Target__c> oldSalesTargetList, List<Sales_Target__c> updatedSalesTargetList, Map<Id, Sales_Target__c> oldSalesTargetMap, Map<Id, Sales_Target__c> newSalesTargetMap) {
    }

    public void OnAfterUpdate(List<Sales_Target__c> oldSalesTargetList, List<Sales_Target__c> updatedSalesTargetList, Map<Id, Sales_Target__c> oldSalesTargetMap, Map<Id, Sales_Target__c> newSalesTargetMap) {

    }

    @Future public static void OnAfterUpdateAsync(Set<Id> updatedSalesTargetIDs) {
    }

    public void OnBeforeDelete(List<Sales_Target__c> salesTargetListToDelete, Map<Id, Sales_Target__c> salesTargetMap) {

    }

    public void OnAfterDelete(List<Sales_Target__c> deletedSalesTargetList, Map<Id, Sales_Target__c> salesTargetMap) {

    }

    @Future public static void OnAfterDeleteAsync(Set<Id> deletedSalesTargetIDs) {

    }

    public void OnUndelete(List<Sales_Target__c> restoredSalesTargetList) {

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