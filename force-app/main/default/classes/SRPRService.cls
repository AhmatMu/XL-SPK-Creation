/**
 * @description       : 
 * @Test Class		  : SRPRService_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 05-10-2023
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   04-14-2023   Novando Utoyo Agmawan   Initial Version
**/

public class SRPRService {
    public void FixSRPRDuplicateName(){
        //-- GET duplicate names of SR and PR
        List <AggregateResult> srprDuplicateNames = [
            SELECT name,
            count (id) num
            FROM sr_pr_notification__c
            WHERE status__c <> 'Rejected'
            GROUP BY name
            HAVING count(Id) > 1
            ORDER BY name ASC
        ];

        system.debug('SRPRService.FixSRPRDuplicateName - srprDuplicateNames : ' + srprDuplicateNames);
        system.debug('SRPRService.FixSRPRDuplicateName - srprDuplicateNames format : ' + json.serialize(srprDuplicateNames));

        //-- put duplicate names to list
        List<String> srprNames = new List<String>();

        if(srprDuplicateNames!=null && !srprDuplicateNames.isEmpty()){
            for(AggregateResult rec : srprDuplicateNames){    
                srprNames.add((string)rec.get('name'));
            }
    
            system.debug('SRPRService.FixSRPRDuplicateName - srprNames : ' + srprNames);
    
            if(srprNames!=null && !srprNames.isEmpty()){
                //-- GET all records of SRPPR (duplicate) 
                List <sr_pr_notification__c> srprDuplicateList = [
                    SELECT 
                    id, 
                    name, 
                    Name2__c,
                    status__c, 
                    Notif_Type__c, 
                    createdDate, 
                    createdBy.name, 
                    Opportunity_id__c, 
                    Opportunity__r.name
                    FROM sr_pr_notification__c
                    WHERE name in : srprNames
                ];
    
                system.debug('SRPRService.FixSRPRDuplicateName - srprDuplicateList : ' + srprDuplicateList);
                system.debug('SRPRService.FixSRPRDuplicateName - srprDuplicateNames format : ' + json.serialize(srprDuplicateList));
    
                if(srprDuplicateList!=null && !srprDuplicateList.isEmpty()){
                    //-- GET last number of SR and PR from custom setting
                    SR_PR__c SPN = SR_PR__c.getorgdefaults();
                    Integer srLastNumber = Integer.valueOf(SPN.SR_Number__c);
                    Integer prLastNumber = Integer.valueOf(SPN.PR_Number__c);
                    
                    String prefixString;
                    String yearString;
                    String monthString;
                    Integer counterNumber;
                    String counterNumberString;
                    Map<String,String> srprNameMap = New Map<String,String>(); 	// to indicate the first
                    
                    //-- fixing the SRPR name 
                    for (sr_pr_notification__c rec : srprDuplicateList) {
                        String srprNameCheck = srprNameMap.get(rec.name);
                        
                        if ( srprNameCheck <> null ) {	// indicate for the 2md, 3rd .. record
                            yearString = String.valueof( rec.createdDate.year() ).right(2);
                            monthString = ('0' + String.valueof( rec.createdDate.year() )).right(2);	
                            
                            if (rec.Notif_Type__c == 'SR') {
                                prefixString = 'SR';
                                counterNumber = srLastNumber;
                                srLastNumber++;
                            }else if (rec.Notif_Type__c == 'PR') {
                                prefixString = 'PR';
                                counterNumber = prLastNumber;
                                prLastNumber++;
                            }
                            
                            if (counterNumber < 999999) {
                                counterNumberString = ('00000' + String.valueof(counterNumber)).right(6);
                            }
                            
                            string idDame = prefixString + '-' + yearString + monthString + '-' + counterNumber;
                            
                            rec.Name2__c = rec.name;
                            rec.name = idDame;
    
                            system.debug('SRPRService.FixSRPRDuplicateName - idDame : ' + idDame);
                        }
                        else {
                            rec.Name2__c = rec.name;
                            srprNameMap.put(rec.name,rec.name); // put the first record of srpr name
                        }
                    }
    
                    system.debug('SRPRService.FixSRPRDuplicateName - srprNameMap : ' + srprNameMap);
                    system.debug('SRPRService.FixSRPRDuplicateName - srprNameMap format : ' + json.serialize(srprNameMap));
                    
                    //-- update the list of SRPR records
                    update srprDuplicateList;
                    
                    //-- update last number od SRP in custom setting
                    SPN.SR_Number__c = srLastNumber;
                    SPN.PR_Number__c = prLastNumber;
                    update SPN;
                }
            }
        }
    }
}