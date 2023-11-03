@isTest(seealldata=true)
public class Test_STR_Main_Controller {
	
	//-- #1
    static testMethod void testMethod_calculationPendingRecurring_STS_STO() {
        Date dt = date.today();
        List<id> listOfID=new List<id>();
        for(Pending_Recurring__c a : [SELECT  
                                                    Ownerid , 
                                                    Owner_Employee_ID__c
                                                FROM Pending_Recurring__c 
                                                WHERE 
                                                    status__c in ('Send to Sales', 'Submit to ORM')]){
            listOfID.add(a.id);
        }
        
        STR_Main_Controller SMC = new STR_Main_Controller();
        SMC.calculationPendingRecurring_STS_STO(listOfID, dt);
    }
    
    
    //-- #2
    static testMethod void testMethod_calculationPendingRecurring_STF() {
        Date dt = date.today();
        List<id> listOfID=new List<id>();
        for(Pending_Recurring__c a : [select id, Owner.Name, Owner.isactive, Search_Link__r.Contract_Item_Rel__r.Product__r.Family, Total_Revenue__c 
        								from Pending_Recurring__c where status__c  in ('Sent to Finance')]){
            listOfID.add(a.id);
        }
        
        STR_Main_Controller SMC = new STR_Main_Controller();
        SMC.calculationPendingRecurring_STF(listOfID, dt);
    }

	
	//-- #3
    static testMethod void testMethod_calculationOpportunity_WBA_WFC() {
        Date dt = date.today();
        List<id> listOfID=new List<id>();
        for(opportunity a : [SELECT  id,
											Ownerid , 
											owner.Employee_ID__c
										FROM opportunity
										WHERE stagename in ('Waiting for BA', 'Waiting for Contract')
											and service_type__c <> 'Simcard Order'
											and closedate > 2019-05-01
											 ]){
            listOfID.add(a.id);
        }
        
        STR_Main_Controller SMC = new STR_Main_Controller();
        SMC.calculationOpportunity_WBA_WFC(listOfID, dt);
    }  
    
    
	//-- #4
    static testMethod void testMethod_calculationOpportunity_ClosedWon() {
        Date dt = date.today();
        List<id> listOfID=new List<id>();
        for(opportunity a : [SELECT  id,
											Ownerid , 
											owner.Employee_ID__c
										FROM opportunity
										WHERE stagename in ('Closed Won')
											and service_type__c <> 'Simcard Order'
											and closedate > 2019-05-01 ]){
            listOfID.add(a.id);
        }
        
        STR_Main_Controller SMC = new STR_Main_Controller();
        SMC.calculationOpportunity_ClosedWon(listOfID, dt);
    }   
}