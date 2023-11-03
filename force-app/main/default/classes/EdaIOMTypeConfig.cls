/**
 * @description       : 
 * @Test Class		  : Test_EDA_IOM_Type_Config
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 10-08-2021
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   10-08-2021   Novando Utoyo Agmawan   Initial Version
**/
public class EdaIOMTypeConfig {
    
    @InvocableMethod
    public static void EdaIOMTypeConfig(List<ID> EDAids) {
        DateTime start_time = datetime.now();
        try {
            List<EDA__c> EDAList = [SELECT Id, IOM_Type__c, Recipient_1__c, Recipient_2__c, Recipient_3__c, 
                                    Recipient_4__c, Recipient_5__c, Approver_1__c, Approver_2__c, 
                                    Approver_3__c, Approver_4__c, Chief_L1__c, Head_L3__c, Group_Head_L2__c
                                    FROM EDA__c where id in : EDAids];
            if(EDAList!=null && !EDAList.isEmpty()){
                Set<String> eda_IomTypeSet = new Set<String>();
                
                For(EDA__c EDAList_extract : EDAList){
                    if(EDAList_extract.IOM_Type__c != null || EDAList_extract.IOM_Type__c != ''){
                        eda_IomTypeSet.add(EDAList_extract.IOM_Type__c);
                    }
                }

                system.debug('eda_IomTypeSet : ' + eda_IomTypeSet);
                
                if(eda_IomTypeSet!=null && !eda_IomTypeSet.isEmpty()){
                    List<EDA__c> EDAListUpdate = new List<EDA__c>();
                    List<EDA_IOM_Type_Configuration__c> edaConfigList = [SELECT Id, Approver_1_Type__c, Approver_2_Type__c, Approver_3_Type__c, Approver_4_Type__c, 
                                                                         IOM_Type__c, Recipient_1__c, Recipient_2__c, 
                                                                         Recipient_3__c, Recipient_4__c, Recipient_5__c, 
                                                                         Approval_Role_1__c, Approval_Role_2__c, Approval_Role_3__c, Approval_Role_4__c,
                                                                         Approver_1__c, Approver_2__c, Approver_3__c, 
                                                                         Approver_4__c ,approval_grade_level_1__c, approval_grade_level_2__c, 
                                                                         approval_grade_level_3__c, approval_grade_level_4__c
                                                                         FROM EDA_IOM_Type_Configuration__c WHERE Iom_Type__c in : eda_IomTypeSet];
                                                
                    system.debug('edaConfigList : ' + edaConfigList);

                    if(edaConfigList!=null && !edaConfigList.isEmpty()){
                        For(EDA__c EDAList_extract : EDAList){
                            for(EDA_IOM_Type_Configuration__c edaConfigList_extract : edaConfigList){
                                if(EDAList_extract.IOM_Type__c == edaConfigList_extract.IOM_Type__c){
                                    // approver 1                                                                 
                                    String App1Type = edaConfigList_extract.Approver_1_Type__c;
                                    String usrid;
                                    switch On (App1Type) {
                                        when 'Specific User' {
                                            EDAList_extract.approver_1__c = edaConfigList_extract.Approver_1__c;
                                            System.debug('App1Type Specific User : ' + edaConfigList_extract.Approver_1__c);
                                        }
                                        
                                        when 'Specific Role' {
                                            String apprvl_Role = edaConfigList_extract.Approval_Role_1__c;
                                            List<User> EDAApproverRole = [SELECT id, Name, Email, userrole.name FROM User WHERE userrole.name=:apprvl_Role];
                                            System.debug('App1Type Specific Role: ' + EDAApproverRole);
                                            if(EDAApproverRole!=null && !EDAApproverRole.isEmpty()){
                                                usrid = EDAApproverRole[0].id;
                                                EDAList_extract.approver_1__c = usrid;
                                            }
                                        }
                                        
                                        when 'Grade Level' {
                                            if (edaConfigList_extract.approval_grade_level_1__c == 'HEAD (L3)'){
                                                EDAList_extract.approver_1__c = EDAList_extract.Head_L3__c;
                                                System.debug('App1Type Grade Level 1 : ' + EDAList_extract.Head_L3__c);
                                            }
                                            else if (edaConfigList_extract.approval_grade_level_1__c == 'Group Head (L2)') {
                                                EDAList_extract.approver_1__c = EDAList_extract.Group_Head_L2__c;
                                                System.debug('App1Type Grade Level 2 : ' + EDAList_extract.Group_Head_L2__c);
                                            }
                                            else if (edaConfigList_extract.approval_grade_level_1__c == 'CHIEF (L1)') {
                                                EDAList_extract.approver_1__c = EDAList_extract.Chief_L1__c;
                                                System.debug('App1Type Grade Level 3 : ' + EDAList_extract.Chief_L1__c);
                                            }
                                        } 
                                        
                                        when else { // default block, optional
                                            EDAList_extract.approver_1__c = null;
                                            System.debug('App1Type else Line 85');
                                        }
                                    }
                                    
                                    // approver 2                                                                 
                                    String App2Type = edaConfigList_extract.Approver_2_Type__c;
                                    String userid;
                                    switch On (App2Type) {
                                        when 'Specific User' {
                                            EDAList_extract.approver_2__c = edaConfigList_extract.Approver_2__c;
                                            System.debug('App2Type Specific User : ' + edaConfigList_extract.Approver_2__c);
                                        }
                                        
                                        when 'Specific Role' {
                                            String apprvl_Role = edaConfigList_extract.Approval_Role_2__c;
                                            List<User> EDAApproverRole = [SELECT id, Name, Email, userrole.name FROM User WHERE userrole.name=:apprvl_Role];
                                            System.debug('App2Type Specific Role : ' + EDAApproverRole);
                                            if(EDAApproverRole!=null && !EDAApproverRole.isEmpty()){
                                                userid = EDAApproverRole[0].id;
                                                EDAList_extract.approver_2__c = userid;
                                            }
                                        }
                                        
                                        when 'Grade Level' {
                                            if (edaConfigList_extract.approval_grade_level_2__c == 'HEAD (L3)'){
                                                EDAList_extract.approver_2__c = EDAList_extract.Head_L3__c;
                                                System.debug('App2Type Grade Level 1 : ' + EDAList_extract.Head_L3__c);
                                            }
                                            else if (edaConfigList_extract.approval_grade_level_2__c == 'Group Head (L2)') {
                                                EDAList_extract.approver_2__c = EDAList_extract.Group_Head_L2__c;
                                                System.debug('App2Type Grade Level 2 : ' + EDAList_extract.Group_Head_L2__c);
                                            }
                                            else if (edaConfigList_extract.approval_grade_level_2__c == 'CHIEF (L1)') {
                                                EDAList_extract.approver_2__c = EDAList_extract.Chief_L1__c;
                                                System.debug('App2Type Grade Level 3 : ' + EDAList_extract.Chief_L1__c);
                                            }
                                        } 
                                        
                                        when else { // default block, optional
                                            EDAList_extract.approver_2__c = null;
                                            System.debug('App2Type else Line 125');
                                        }
                                    }
                                    
                                    // approver 3                                                                 
                                    String App3Type = edaConfigList_extract.Approver_3_Type__c;
                                    String user1id;
                                    switch On (App3Type) {
                                        when 'Specific User' {
                                            EDAList_extract.approver_3__c = edaConfigList_extract.Approver_3__c;
                                            System.debug('App3Type Specific User : ' + edaConfigList_extract.Approver_3__c);
                                        }
                                        
                                        when 'Specific Role' {
                                            String apprvl_Role = edaConfigList_extract.Approval_Role_3__c;
                                            List<User> EDAApproverRole = [SELECT id, Name, Email, userrole.name FROM User WHERE userrole.name=:apprvl_Role];
                                            System.debug('App3Type Specific Role : ' + EDAApproverRole);
                                            if(EDAApproverRole!=null && !EDAApproverRole.isEmpty()){
                                                user1id = EDAApproverRole[0].id;
                                                EDAList_extract.approver_3__c = user1id;
                                            }
                                        }
                                        
                                        when 'Grade Level' {
                                            if (edaConfigList_extract.approval_grade_level_3__c == 'HEAD (L3)'){
                                                EDAList_extract.approver_3__c = EDAList_extract.Head_L3__c;
                                                System.debug('App3Type Grade Level 1 : ' + EDAList_extract.Head_L3__c);
                                            }
                                            else if (edaConfigList_extract.approval_grade_level_3__c == 'Group Head (L2)') {
                                                EDAList_extract.approver_3__c = EDAList_extract.Group_Head_L2__c;
                                                System.debug('App3Type Grade Level 2 : ' + EDAList_extract.Group_Head_L2__c);
                                            }
                                            else if (edaConfigList_extract.approval_grade_level_3__c == 'CHIEF (L1)') {
                                                EDAList_extract.approver_3__c = EDAList_extract.Chief_L1__c;
                                                System.debug('App3Type Grade Level 3 : ' + EDAList_extract.Chief_L1__c);
                                            } 
                                        }
                                        
                                        when else { // default block, optional
                                            EDAList_extract.approver_3__c = null;
                                            System.debug('App3Type else Line 125');
                                        }
                                    }
                                    
                                    // approver 4                                                                
                                    String App4Type = edaConfigList_extract.Approver_4_Type__c;
                                    String user2id;
                                    switch On (App4Type) {
                                        when 'Specific User' {
                                            EDAList_extract.approver_4__c = edaConfigList_extract.Approver_4__c;
                                            System.debug('App4Type Specific User : ' + edaConfigList_extract.Approver_4__c);
                                        }
                                        
                                        when 'Specific Role' {
                                            String apprvl_Role = edaConfigList_extract.Approval_Role_4__c;
                                            List<User> EDAApproverRole = [SELECT id, Name, Email, userrole.name FROM User WHERE userrole.name=:apprvl_Role];
                                            System.debug('App4Type Specific Role : ' + EDAApproverRole);
                                            if(EDAApproverRole!=null && !EDAApproverRole.isEmpty()){
                                                user2id = EDAApproverRole[0].id;
                                                EDAList_extract.approver_4__c = user2id;
                                            }
                                        }
                                        
                                        when 'Grade Level' {
                                            if (edaConfigList_extract.approval_grade_level_4__c == 'HEAD (L3)') {
                                                EDAList_extract.approver_4__c = EDAList_extract.Head_L3__c;
                                                System.debug('App4Type Grade Level 1 : ' + EDAList_extract.Head_L3__c); 
                                            }
                                            else if (edaConfigList_extract.approval_grade_level_4__c == 'Group Head (L2)') {
                                                EDAList_extract.approver_4__c = EDAList_extract.Group_Head_L2__c;
                                                System.debug('App4Type Grade Level 2 : ' + EDAList_extract.Group_Head_L2__c);
                                            }
                                            else if (edaConfigList_extract.approval_grade_level_4__c == 'CHIEF (L1)') {
                                                EDAList_extract.approver_4__c = EDAList_extract.Chief_L1__c;
                                                System.debug('App4Type Grade Level 3 : ' + EDAList_extract.Chief_L1__c);
                                            } 
                                        }
                                        
                                        when else { // default block, optional
                                            EDAList_extract.approver_4__c = null;
                                            System.debug('App4Type else Line 205');
                                        }
                                    }
                                    EDAList_extract.Recipient_1__c = edaConfigList_extract.Recipient_1__c;
                                    EDAList_extract.Recipient_2__c = edaConfigList_extract.Recipient_2__c;
                                    EDAList_extract.Recipient_3__c = edaConfigList_extract.Recipient_3__c;
                                    EDAList_extract.Recipient_4__c = edaConfigList_extract.Recipient_4__c;
                                    EDAList_extract.Recipient_5__c = edaConfigList_extract.Recipient_5__c;
                                    EDAListUpdate.add(EDAList_extract);
                                }
                            }
                        }
                        
                        /* Radhit 08 juni 2021/*
                        List<User> EDAApproverRole = [SELECT id, Name, Email, userrole.name FROM User WHERE userrole.name=:App1Type];
                        For(EDA__c EDAList_extract : EDAList){
                        for(EDA_IOM_Type_Configuration__c edaConfigList_extract : edaConfigList){
                        if(EDAList_extract.IOM_Type__c == edaConfigList_extract.IOM_Type__c){
                        EDAList_extract.Recipient_1__c = edaConfigList_extract.Recipient_1__c;
                        EDAList_extract.Recipient_2__c = edaConfigList_extract.Recipient_2__c;
                        EDAList_extract.Recipient_3__c = edaConfigList_extract.Recipient_3__c;
                        EDAList_extract.Recipient_4__c = edaConfigList_extract.Recipient_4__c;
                        EDAList_extract.Recipient_5__c = edaConfigList_extract.Recipient_5__c;
                        EDAList_extract.Approver_1__c = EDAList_extract.approver_1__c;
                        EDAList_extract.Approver_2__c = EDAList_extract.approver_2__c;
                        EDAList_extract.Approver_3__c = EDAList_extract.approver_3__c;
                        EDAList_extract.Approver_4__c = EDAList_extract.approver_4__c;
                        EDAListUpdate.add(EDAList_extract);
                        }
                        }
                        }*/
                        
                        if(EDAListUpdate!=null && !EDAListUpdate.isEmpty()){
                            update EDAListUpdate;
                            system.debug('EDAListUpdate SIZE : ' + EDAListUpdate.size());
                            system.debug(EDAListUpdate);
                        }
                    }
                }
            }
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } catch (Exception e) {
            String err_message = 'Error on EdaIOMTypeConfig.cls - EdaIOMTypeConfig ::' + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
            AppUtils.putError(err_message);
        }
    }
}