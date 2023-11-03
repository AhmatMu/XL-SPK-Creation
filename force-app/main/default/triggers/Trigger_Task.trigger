trigger Trigger_Task on Task (after update, before update,before insert,after insert,before delete,after delete) {
    if(system.label.IS_TRIGGER_TASK_ON=='YES')
    {
 Integer DaysBetween=0;
    if(trigger.isafter)
    {
    	if(trigger.isdelete)
    		{
    			for(Task T:trigger.old)
    			{
    			if(T.Activity_Number__c!=null && !T.Subject.contains('Parallel'))
    			{
    				list<Task> LT=[SELECT id,Activity_Number__c,Start_Date__c,ActivityDate FROM Task WHERE WhatID=:T.WhatID AND ID<>:T.id AND Activity_Number__c>:T.Activity_Number__c];
    				if(LT.size()>0)
    				{
    					for(Task Taskedit:LT)
    					{
    						Taskedit.Activity_Number__c=Taskedit.Activity_Number__c-1;
    						if(taskedit.activity_Number__c==T.Activity_Number__c)
    						{
    							daysbetween=taskedit.start_date__c.daysbetween(taskedit.activitydate);
    							taskedit.start_date__c=T.start_date__c;
    							taskedit.activitydate=taskedit.start_date__c.adddays(daysbetween);
    						}
    					}
						update LT;
    				}
    			}
    			}
    		}
    		else
    		{
    	for(Task T:system.trigger.new)
    	{
    		if(trigger.isupdate)
    		{
    			
    		Task OldT=trigger.oldmap.get(T.id);
    		if(T.Activity_Number__c!=null)
    		{
    			
    			if(T.status=='Completed' && OldT.status!='Completed' && T.Parallel__c==false)
    			{
    				list<Task> LT=[SELECT id,Activity_Number__c,Active__c FROM Task WHERE WhatID=:T.whatid AND Activity_Number__c=:T.Activity_Number__c+1];
    				
    				if(LT.size()==0)
    				{
    					SR_PR_Notification__c SPN=new SR_PR_Notification__c();
    					SPN.ID=T.WhatID;
    					SPN.Project_Complete_Date__c=system.today();
    					SPN.Status__c='Waiting Berita Acara';
    					update SPN;
    				}
    				else
    				{
    				for(Task Tas:LT)
    				{
    					Tas.Active__c=true;
    				}
    				update LT;
    				}
    			}
    			if(T.ActivityDate!=OldT.ActivityDate)
    			{
    			
    				
    				list<Task> LT=[SELECT id,Activity_Number__c,Active__c,ActivityDate,Start_Date__c FROM Task WHERE WhatID=:T.whatid AND Activity_Number__c=:T.Activity_Number__c+1];
    				for(Task Tas:LT)
    				{
    					Daysbetween=Tas.Start_Date__c.daysbetween(Tas.ActivityDate);
    					Tas.Start_Date__c=T.ActivityDate.Adddays(1);
    					Tas.ActivityDate=Tas.Start_Date__c.Adddays(daysbetween);
    				}
    				update LT;
    			}
    		}
    		}
    		if(trigger.isinsert)
    		{
    			if(T.Activity_Number__c!=null && T.Parallel__c==false)
    			{
    				list<Task> LT=[SELECT id,Activity_Number__c,Start_Date__c,ActivityDate FROM Task WHERE WhatID=:T.WhatID AND ID<>:T.id AND Activity_Number__c>=:T.Activity_Number__c AND Createddate<:system.now().addminutes(-1)];
    				if(LT.size()>0)
    				{
    					for(Task Taskedit:LT)
    					{
    						Taskedit.Activity_Number__c=Taskedit.Activity_Number__c+1;
    						if(taskedit.activity_Number__c==T.Activity_Number__c+1)
    						{
    							daysbetween=taskedit.start_date__c.daysbetween(taskedit.activitydate);
    							taskedit.start_date__c=T.activitydate.adddays(1);
    							taskedit.activitydate=taskedit.start_date__c.adddays(daysbetween);
    						}
    					}
						update LT;
    				}
				/*		list<Task> LT2=[SELECT id,Activity_Number__c,Start_Date__c,ActivityDate FROM Task WHERE WhatID=:T.WhatID];
    				if(LT2.size()>0)
    				{
    					for(Task Taskedit2:LT2)
    					{
    						Taskedit2.Activity_Number__c=Taskedit2.Activity_Number__c+1;
    					}
						update LT2;
    				}
    				*/
    			}
    		}
    		
    	}
    }
    }
    }
       if(trigger.isbefore && !trigger.isdelete)
    {
    	
    			for(Task T:system.trigger.new)
    			{
    				if(trigger.isupdate)
    		{
    		Task OldT=trigger.oldmap.get(T.id);
    		if(T.Activity_Number__c!=null)
    		{
    			
    			if(T.status=='Complete' && OldT.status!='Complete')
    			{
    				T.Active__c=false;
    			}
    			if(T.Roadblock__c==true && OldT.roadblock__c==false)
    			{
    				T.Roadblock_Start_Date__c=system.today();
    			}
    		}
    		
    		}
    			if(trigger.isinsert)
    		{
    			if(T.Activity_Number__c!=null)
    			{
    				if(T.Start_Date__c==null||T.ActivityDate==null)
    				{
    					T.adderror('Start Date or Due Date must be filled');
    				}
    			}
    		}
    			}
    	
    	
    }
}