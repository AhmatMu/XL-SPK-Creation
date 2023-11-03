/**
 * @description       : 
 * @Test Class        : REST_Account_Callout_Test
 * @author            : Novando Utoyo Agmawan
 * @group             : 
 * @last modified on  : 11-10-2022
 * @last modified by  : Novando Utoyo Agmawan
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   10-07-2022   Novando Utoyo Agmawan   Initial Version
**/

public class REST_Account_Callout_Invoke {
    @InvocableMethod(label='Execute REST Account Callout')    
    public static List<Results> execute(List<Requests> requests) {
        List<Results> responseWrapper = new List<Results>();
        Results response = new Results();

        for (Requests curRequest : requests) {
            system.debug('curRequest.List_contactRec : ' + curRequest.List_contactRec);

            REST_Account_Callout.createPartner_async(json.serialize(curRequest.accountRec),json.serialize(curRequest.List_contactRec));
        }

        response.isSuccess = true;
        responseWrapper.add(response);

        return responseWrapper;
    }

    public class Requests {
        @InvocableVariable(required=true)
        public Account accountRec;

        @InvocableVariable(required=true)
        public List<Contact> List_contactRec;
    }

    public class Results {
        @InvocableVariable
        public Boolean isSuccess;
    }
}