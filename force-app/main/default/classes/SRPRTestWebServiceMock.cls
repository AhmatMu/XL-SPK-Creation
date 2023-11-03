/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
global class SRPRTestWebServiceMock implements WebServiceMock {

     global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
           	sapComDocumentSapRfcFunctions2.ZEXD_SF_SRPRResponse_element RespELement=new sapComDocumentSapRfcFunctions2.ZEXD_SF_SRPRResponse_element();
           	sapComDocumentSapRfcFunctions2.ZEXDSDTT00054 result=new sapComDocumentSapRfcFunctions2.ZEXDSDTT00054();
           	list <sapComDocumentSapRfcFunctions2.ZEXDSDST00101> listsrpr=new list <sapComDocumentSapRfcFunctions2.ZEXDSDST00101>();
        sapComDocumentSapRfcFunctions2.ZEXDSDST00101 srpr=new sapComDocumentSapRfcFunctions2.ZEXDSDST00101();
        sapComDocumentSapRfcFunctions2.ZEXDSDTT00052 msg=new sapComDocumentSapRfcFunctions2.ZEXDSDTT00052();
        list<sapComDocumentSapRfcFunctions2.ZEXDSDST00097> listmsg=new list<sapComDocumentSapRfcFunctions2.ZEXDSDST00097>();
        sapComDocumentSapRfcFunctions2.ZEXDSDST00097 message=new sapComDocumentSapRfcFunctions2.ZEXDSDST00097();
        message.Message='Yes';
        message.Message_No='1';
        listmsg.add(message);
        msg.item=listmsg;
        srpr.Messages=msg;
        srpr.SAP_ID='202020';
        srpr.IS_ERROR='';
        listsrpr.add(srpr);
        result.item=listsrpr;

       RespElement.FE_RETURN=result;
        // TO DO: implement unit test
        response.put('response_x',RespElement);
    }
}