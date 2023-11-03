/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 12-05-2022
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   11-05-2022   Doddy Prima   Initial Version
**/
public  class SetOpportunityAttributes {
    
    @InvocableMethod
    public static void SetOpportunityAttributes ( List<Opportunity> opptyList  ) {    
        SYSTEM.DEBUG ('================== IN SetOpportunityAttributes ========');
        

        string ownerRoleType = '';
        string errorMsg = '';
        string relatedSFIDs;

        //-- get all owner-sf-id
        Set<ID> opptyIDs = new Set<ID>();
        Set<ID> ownerIDs = new Set<ID>();
        for (Opportunity opptyREC : opptyList) {
            opptyIDs.add(opptyREC.id);
            relatedSFIDs = relatedSFIDs + opptyREC.id + '; ';
            ownerIDs.add(opptyREC.ownerId);
        }

        opptyList = [
            SELECT id, ownerid,
                owner.userrole.name,
                owner.profile.name,
                owner.managerid,
                owner.manager.employee_id__c,
                owner.manager.managerid,
                owner.manager.manager.employee_id__c
            FROM Opportunity
            WHERE id in :opptyIDs
        ];
        system.debug(' == opptyList : ' + opptyList);

        Map<Id, User> userMap = New Map<Id, User> ( [
            SELECT id, 
                userrole.name,
                profile.name,
                managerid,
                manager.employee_id__c,
                manager.userRole.name,

                manager.managerid,
                manager.manager.employee_id__c,
                manager.manager.userRole.name
            FROM User
            WHERE id in :ownerIDs
        ]);
		system.debug(' == userMap : ' + userMap);
        try {
            
            //-- loop for opportunity list
            for (Opportunity opptyREC : opptyList) {
                User userTemp = userMap.get ( opptyREC.ownerid);

                if (opptyREC.owner.userrole.name.contains('Group Head')) {
                    ownerRoleType = 'GH';
                }
                else if (opptyREC.owner.userrole.name.contains('Head')) {
                    ownerRoleType = 'SM';
                }
                else {
                    ownerRoleType = 'AM';
                }

                //-- reset first for SM and GH
                opptyREC.Sales_Manager_Owner__c  = null;
                opptyREC.GM_Sales_of_Owner__c = null;
                opptyREC.sales_manager_for_Approval__c = null;
                opptyREC.Group_Head_for_Approval__c = null;

                switch on ownerRoleType {
                    when 'AM' {
                        
                        if ( userTemp <> null ) {
                            
                            if ( userTemp.managerid <> null && userTemp.manager.userRole.name.contains('Group Head')) {
                                //-- set GH (if the manager AM is GH) 
                                opptyREC.GM_Sales_of_Owner__c = userTemp.managerId;

                                //handle for approval process
                                opptyREC.sales_manager_for_Approval__c = userTemp.managerId;
                                opptyREC.Group_Head_for_Approval__c = userTemp.ManagerId;
                                //-- SM dibiarkan kosong
                            }
                            else if ( userTemp.managerid <> null && userTemp.manager.userRole.name.contains('Head')) {
                                //-- set SM
                                opptyREC.Sales_Manager_Owner__c = userTemp.managerId;

                                //-- set GH
                                opptyREC.GM_Sales_of_Owner__c = userTemp.manager.managerId;

                                // -- Handle for approval process
                                // -- set SM
                                opptyREC.sales_manager_for_Approval__c = userTemp.managerId;
                                // -- set GH
                                opptyREC.Group_Head_for_Approval__c = userTemp.manager.ManagerId;
                            }
                            
                        }

                    
                    }
                    when 'SM' {
                        if ( userTemp <> null ) {
                            //-- set SM
                            opptyREC.Sales_Manager_Owner__c = userTemp.id;
                            opptyREC.sales_manager_for_Approval__c = userTemp.id;
                            
                            if ( userTemp.managerid <> null && userTemp.manager.userRole.name.contains('Group Head') ) {
                                //-- set GH
                                opptyREC.GM_Sales_of_Owner__c = userTemp.managerId;
                                opptyREC.Group_Head_for_Approval__c = userTemp.managerId;

                            }
                        }

                    }
                    when 'GH' {
                        //-- set GH
                        opptyREC.GM_Sales_of_Owner__c = userTemp.id;
                    }
                } 
            }


            //-- update opptyList
            update opptyList;

        }
        catch (Exception e) {
            string notes = 'Error on SetOpportunityAttributes.SetOpportunityAttributes method.'; string message =  e.getmessage() + ' - ' +e.getStacktraceString() ; integer lineNumber = e.getLineNumber();
            
            errorMsg = notes + '::' +  message + '::' + lineNumber + '::' +  relatedSFIDs; apputils.puterror(errorMsg);
            system.debug ('===== errorMsg : ' + errorMsg);
            
        }

    }
      
}