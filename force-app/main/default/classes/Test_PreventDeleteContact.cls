@isTest(seealldata=true)
public class Test_PreventDeleteContact {
    static testmethod void testPreventConDel(){
        user u=[SELECT id from user WHERE Name='Nityo Triantono' LIMIT 1];
        Account A=[SELECT id from Account where Ownerid=:u.id AND Organization_Type__c='Head Office' LIMIT 1];
        test.starttest();
        system.runas(u){
            Contact conRecord = new Contact();
            conRecord.Lastname = 'Test Contact';
            conRecord.AccountId = A.Id;
            insert conRecord;
            
            try{
                delete conRecord;
            }catch(DMLexception e){
                system.assert(e.getMessage().contains('Only Administrator can delete record'),'Only Administrator can delete record'); 
            }
            test.stoptest();
        }        
    }
}