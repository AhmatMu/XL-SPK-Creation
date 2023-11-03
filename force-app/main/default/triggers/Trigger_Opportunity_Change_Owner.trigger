trigger Trigger_Opportunity_Change_Owner on Opportunity (after update) {
if (label.Is_Trigger_Opportunity_Change_Owner_On== 'YES') {
    
    List<Id> oppIds = new List<Id>(); //opportunity id
    
    String Profamily;
    String ProductCode;
    String Forecast = System.Label.Forecast;
    String Forecast_detail = System.Label.Forecast_Detail;
    String tempUnique_ID;
    String employee_id;
    List <Sales_Target_and_Revenue__c> STRToInsert = new List <Sales_Target_and_Revenue__c> ();
    
    for (Opportunity oppNew:system.trigger.new) {
        Opportunity oppOld=Trigger.oldMap.get(oppNew.id);
        Sales_Target_and_Revenue__c str = new Sales_Target_and_Revenue__c(); //instantiate STR
        Sales_Target_and_Revenue_Detail__c strd = new Sales_Target_and_Revenue_Detail__c(); //instantiate STR_detail
    if(oppOld.OwnerId != oppNew.OwnerId){
         system.debug('===== Masuk : ');
        try
        {
            String TempSTR_ID;
            system.debug('===== Masuk try : ');
            List<Sales_Target_and_Revenue_Detail__c> toUpdateSTRD = new List<Sales_Target_and_Revenue_Detail__c>();
            toUpdateSTRD = [select id,Sales_Target_and_Revenue__c from Sales_Target_and_Revenue_Detail__c where Opportunity__c =: oppNew.Id];
            if(toUpdateSTRD.size()>0){
                toUpdateSTRD[0].AM__c=oppNew.OwnerId;
                TempSTR_ID = toUpdateSTRD[0].Sales_Target_and_Revenue__c;
                
                update toUpdateSTRD;
            }
            else{
                upsert strd Unique_ID__c;
            }
            
            List<Sales_Target_and_Revenue__c> toUpdateSTR = new List<Sales_Target_and_Revenue__c>();
            toUpdateSTR = [select id,Unique_ID__c from Sales_Target_and_Revenue__c where id =: TempSTR_ID];
           
            List<String> lstUnique = toUpdateSTR[0].Unique_ID__c.split('-');
                       
             List<Opportunity> allOpp = [SELECT Name,Id, StageName, CloseDate, LeadSource, Amount, Owner.Name, Owner.Username,Owner.Employee_ID__c,Account.Id FROM Opportunity WHERE Id =: oppNew.Id];
        
             for (Opportunity opty: allOpp) {
                 employee_id=opty.Owner.Employee_ID__c;
             }
            
            system.debug('===== opty1: '+allOpp);
            
            tempUnique_ID = employee_id+'-'+lstUnique[1]+'-'+lstUnique[2]+'-'+lstUnique[3]+'-'+lstUnique[4];
            
            system.debug('===== Masuk1 : '+employee_id);
                 
            if(toUpdateSTR.size()>0){
                toUpdateSTR[0].AM__c = oppNew.OwnerId;
                toUpdateSTR[0].User__c =oppNew.OwnerId;
                
                toUpdateSTR[0].Unique_ID__c = tempUnique_ID;
                update toUpdateSTR;
            }
                    
        } 
        catch (system.Dmlexception e)
        {
         system.debug (e);
        }
    }    
   }//end for
  }//end activation
}