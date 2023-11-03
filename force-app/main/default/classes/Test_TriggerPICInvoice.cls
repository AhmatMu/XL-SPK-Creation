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
@isTest(seealldata=true)
public class Test_TriggerPICInvoice {

    static testMethod void myUnitTest() {
        Test.starttest();
        Account tmpAcc = new Account ();
        tmpAcc.name = 'Test';
        tmpAcc.Payer_For_GSM_Invoice__c = true;
        tmpAcc.No_NPWP__c= '123456789012345';
        tmpAcc.LA_Number__c = '12345';
        tmpAcc.Customer_VAT_Name__c  = 'bro';
        
        tmpAcc.ShippingStreet = 'jl. cempaka';
        tmpAcc.BillingStreet = 'jl. cempaka';
        tmpAcc.BillingCity = 'Jakarta';
        tmpAcc.BillingState = 'DKI';
        
        insert tmpAcc;

        tmpAcc.name = 'Test 2';
        update tmpAcc;


        Test.stoptest();

    }

}