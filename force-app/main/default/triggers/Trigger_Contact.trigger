/**
 * @description       : 
 * @Test Class        : TA_AT_ContactUpdateDealerInIdexPro_Test
 * @author            :
 * @group             : 
 * @last modified on  : 12-26-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   11-29-2022   Novando Utoyo Agmawan   Initial Version
**/

trigger Trigger_Contact on Contact (after insert, after update, before insert, before update) {
    if(system.label.IS_TRIGGER_CONTACT_ON=='YES')
    {
        if(trigger.isinsert)
        {
            if(trigger.isafter)
            {
                for(Contact contactNew:system.trigger.new)
                {
                    // HitsapComDocumentSapSoap.InsertContact(String.valueof(C.id),String.Valueof(C.AccountID),'Contact Person;');
                }
            }
        }
        if(trigger.isupdate)
        {
            if(trigger.isafter)
            {
                for(Contact contactNew:system.trigger.new)
                {
                    Contact contactOld=Trigger.oldMap.get(contactNew.id);

                    if(contactOld.Accountid==contactNew.AccountID && contactNew.AccountID!=null){
                        if(contactOld.Idexpro_ProfileID__c == contactNew.Idexpro_ProfileID__c){
                            list<AccountContactRelation> ACRList=[
                                SELECT AccountID,
                                Roles, 
                                mode__c
                                FROM AccountContactRelation
                                WHERE Contactid=:contactNew.id
                            ];
                            
                            if(!Test.isRunningTest()) {
                                for(AccountContactRelation acr:ACRList){
                                    HitsapComDocumentSapSoap.UpdateContact2(
                                        String.valueof(contactNew.id),
                                        String.valueof(acr.Accountid),
                                        acr.Roles, acr.mode__c
                                    );
                                } 
                            }
                        }
                    }
                }
            }
        }
        
    }
}