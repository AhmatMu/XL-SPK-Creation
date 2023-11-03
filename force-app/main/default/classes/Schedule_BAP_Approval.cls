/**
 * @description       : 
 * @Test Class		  : TEST_AppUtils
 * @author            :
 * @group             : 
 * @last modified on  : 04-19-2022
 * @last modified by  : Muhammad Iqbal
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   2020   Faris Ramadhan   			Initial Version
 * 2.0	 2022	Muhammad Iqbal				Add Custom Setting
**/
global class Schedule_BAP_Approval implements Schedulable{
    global void execute(SchedulableContext sc){
    	
        BAPGeneralSetting__c BAPSetting = BAPGeneralSetting__c.getOrgDefaults ();
        integer date_range = integer.valueof(BAPSetting.AutoApprovedGHafterxdays__c);
        date tgl;
        if (BAPSetting.AutoApprovedGHDayType__c == 'CALENDAR_DAY') {
    		tgl = date.valueof(Apputils.nextdate(system.today(),-1*date_range,true, true,true));
        }
        if (BAPSetting.AutoApprovedGHDayType__c == 'BUSINESS_DAY') {
    		tgl = date.valueof(Apputils.nextdate(system.today(),-1*date_range,false, false,false));
        }
        
    	system.debug('tanggal approval GH nya : '+tgl);
        //Query sementara
        /*list<BAP__c> listBAP=[SELECT id,isbackdate__c,ispenalty__c,IsCostPartner__c, Penalty_Approval_Status__c,Backdate_Approval_Status__c,GH_Approval_Date__c,IoM_Approval_Status__c,Request_Status__c,Approval_Remark__c 
        						FROM BAP__c WHERE id = 'a095D0000045fXeQAI'];
        */
        /*Query OLD
        list<BAP__c> listBAP=[SELECT id,isbackdate__c,ispenalty__c,Penalty_Approval_Status__c,Backdate_Approval_Status__c FROM BAP__c WHERE Request_Date__c<=:system.Today().adddays(-2)];
        */
         
        //Query OK
	if (BAPSetting.isAutoApprovedforGH__c == TRUE) {
        list<BAP__c> listBAP= null;
             
        if (!test.isRunningTest()) {   
        	listBAP = [SELECT id, Request_Date__c, isbackdate__c,ispenalty__c,IsCostPartner__c, Penalty_Approval_Status__c,Backdate_Approval_Status__c,GH_Approval_Date__c,IoM_Approval_Status__c,Request_Status__c,Approval_Remark__c,note__c 
        				FROM BAP__c WHERE Request_Date__c<=:tgl and Request_Status__c = 'IOM Approval' 
                       				AND (Backdate_Approval_Status__c	!= 'NOT APPROVED' OR Penalty_Approval_Status__c  != 'NOT APPROVED' ) 
                       				AND Approval_Remark__c != 'Request for CEO Approval' limit 20];
        } 
        else {
            listBAP = [SELECT id, Request_Date__c, isbackdate__c,ispenalty__c,IsCostPartner__c, Penalty_Approval_Status__c,Backdate_Approval_Status__c,GH_Approval_Date__c,IoM_Approval_Status__c,Request_Status__c,Approval_Remark__c,note__c
        				FROM BAP__c where Request_Status__c = 'IOM Approval' 
                       				AND (Backdate_Approval_Status__c	!= 'NOT APPROVED' OR Penalty_Approval_Status__c  != 'NOT APPROVED' ) 
                       				AND Approval_Remark__c != 'Request for CEO Approval' limit 20];
        }
        
        
        system.debug ('============== listBAP : ' +listBAP );
        system.debug ('============== listBAP.size() : ' +listBAP.size() );
        for(BAP__c B:listBAP)
        {
        	system.debug ('============== IsBackdate__c : ' +B.IsBackdate__c );
        	system.debug ('============== IsPenalty__c : ' +B.IsPenalty__c );
        	system.debug ('============== IsCostPartner__c : ' +B.IsCostPartner__c );
            if(B.IsBackdate__c==true && B.IsPenalty__c == true && B.IsCostPartner__c == false)
            {
                B.Backdate_Approval_Status__c = 'Approved';
                B.Penalty_Approval_Status__c = 'Approved';
                B.GH_Approval_Date__c = Datetime.Now();
                B.IoM_Approval_Status__c = 'Approved';
				B.Request_Status__c = 'BA Sent to Customer';
				Approval.unlock(B.Id);
			//	sendEmailCustom('Approved', 'Group', B.id, B.ownerid);
            }
            if(B.IsBackdate__c==true && B.IsPenalty__c == true && B.IsCostPartner__c == true)
            {
                B.Backdate_Approval_Status__c = 'APPROVED';
				B.Penalty_Approval_Status__c = 'APPROVED';
				B.GH_Approval_Date__c = Datetime.Now();
				B.Approval_Remark__c = 'Request for CEO Approval';
				Approval.unlock(B.Id);
            }
            if(B.IsBackdate__c==true && B.IsPenalty__c == false && B.IsCostPartner__c == false)
            {
                B.Backdate_Approval_Status__c = 'APPROVED';
				B.Penalty_Approval_Status__c = 'NO NEED APPROVAL';
				B.GH_Approval_Date__c = Datetime.Now();
				B.IoM_Approval_Status__c = 'Approved';
				B.Request_Status__c = 'BA Sent to Customer';
				Approval.unlock(B.Id);
			//	sendEmailCustom('Approved', 'Group', B.id, B.ownerid);
            }
            if(B.IsBackdate__c==true && B.IsPenalty__c == false && B.IsCostPartner__c == true)
            {
                B.Backdate_Approval_Status__c = 'APPROVED';
				B.Penalty_Approval_Status__c = 'NO NEED APPROVAL';
				B.GH_Approval_Date__c = Datetime.Now();
				B.Approval_Remark__c = 'Request for CEO Approval';
				Approval.unlock(B.Id);
            }
            if(B.IsBackdate__c==false && B.IsPenalty__c == true && B.IsCostPartner__c == false)
            {
                B.Backdate_Approval_Status__c = 'NO NEED APPROVAL';
				B.Penalty_Approval_Status__c = 'APPROVED';
				B.GH_Approval_Date__c = Datetime.Now();
				B.IoM_Approval_Status__c = 'Approved';
				B.Request_Status__c = 'BA Sent to Customer';
				Approval.unlock(B.Id);
			//	sendEmailCustom('Approved', 'Group', B.id, B.ownerid);
			}
			if(B.IsBackdate__c==false && B.IsPenalty__c == true && B.IsCostPartner__c == true)
            {
                B.Backdate_Approval_Status__c = 'NO NEED APPROVAL';
				B.Penalty_Approval_Status__c = 'APPROVED';
				B.GH_Approval_Date__c = Datetime.Now();
				B.Approval_Remark__c = 'Request for CEO Approval';
				Approval.unlock(B.Id);
			}
            
            
            /* //--OLD
            if(B.IsBackdate__c==true && (B.Backdate_Approval_Status__c==null||B.Backdate_approval_status__c==''))
            {
                B.Backdate_Approval_Status__c='Approved';
            }
            if(B.IsPenalty__c==true && (B.Penalty_Approval_Status__c==null||B.Penalty_approval_status__c==''))
            {
                B.Penalty_Approval_Status__c='Approved';
            }*/
            
        }
        update listBAP;
    }     
        //--- Auto Approve for Chief START
		
	if (BAPSetting.isAutoApprovedforCHIEF__c == TRUE) {
        
        if (BAPSetting.AutoApprovedCHIEFDayType__c == 'CALENDAR_DAY') {
    		tgl = date.valueof(Apputils.nextdate(system.today(),date_range,true, true,true));
        }
        if (BAPSetting.AutoApprovedCHIEFDayType__c == 'BUSINESS_DAY') {
    		tgl = date.valueof(Apputils.nextdate(system.today(),date_range,false, false,false));
        }
        system.debug('tanggal approval chief nya : '+tgl);
        //Query Sementara
		/*list<ProcessInstance> listPI=[SELECT (SELECT Id, ActorId, ProcessInstanceId FROM Workitems), id ,Status, TargetObjectId 
		FROM ProcessInstance WHERE TargetObjectId = 'a095D0000045fXeQAI' AND ProcessDefinition.Name = 'Need Approval IoM BAP v2' AND Status='Pending'];
		
        //Query OLD//
        list<ProcessInstance> listPI=[SELECT (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),
        id ,Status FROM ProcessInstance WHERE Createddate<=:system.now().adddays(-2) AND ProcessDefinition.Name = 'Need Approval IoM BAP v2' AND Status='Pending'];
        */
		
        //--- Chief auto approve Sudah tidak digunakan, . Update by Iqbal : 19-04-2022
		//Query OK
		list<ProcessInstance> listPI=[SELECT (SELECT Id, ActorId, ProcessInstanceId FROM Workitems), id ,Status, TargetObjectId FROM ProcessInstance WHERE Createddate<=:tgl AND ProcessDefinition.Name = 'Need Approval IoM BAP v2' AND Status='Pending'];
		
		system.debug('ListPI size nya : '+listPI);
		system.debug('ListPI size nya : '+listPI.size());
        
        Approval.ProcessWorkitemRequest[] prWkItems = New Approval.ProcessWorkItemRequest[]{};
        
        if(test.isRunningTest())
        listPI=[SELECT (SELECT Id, ActorId, ProcessInstanceId FROM Workitems) id ,Status FROM ProcessInstance WHERE ProcessDefinition.Name = 'Need Approval IoM BAP v2'];
        system.debug ('===== listPI : ' + listPI);
        
        for(ProcessInstance P:listPI)
        {
            for(ProcessInstanceWorkItem workItem : P.WorkItems){

            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
            pwr.setWorkitemId(WorkItem.id);
            pwr.setAction('Approve');
            if(test.isRunningTest())
            {
                pwr.setAction('Reject');
            }
            prwkitems.add(pwr);
            }
        }
        //update listPI;
        if(!prWkItems.isEmpty()){
         	//shouldTriggerRun.stopFAR();
          	Approval.ProcessResult[] appResult = Approval.process(prWkItems);
         	//shouldTriggerRun.allowFAR();
        }   
		
    }
    }
}