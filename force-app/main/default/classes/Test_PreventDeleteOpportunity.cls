@isTest(seealldata=true)
public class Test_PreventDeleteOpportunity {
    static testmethod void testPreventOppDel(){
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        Account A=[SELECT id from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
        test.starttest();
        system.runas(u){
            Opportunity oppRecord = new Opportunity();
            oppRecord.Name = 'Test Opp';
            oppRecord.CloseDate=system.today().adddays(10);
            oppRecord.Accountid=A.id;
            oppRecord.StageName='Prospecting';
            insert oppRecord;
            
            try{
                delete oppRecord;
            }catch(DMLexception e){
                system.assert(e.getMessage().contains('Only Administrator can delete record'),'Only Administrator can delete record'); 
            }
            test.stoptest();
        }
    }
}