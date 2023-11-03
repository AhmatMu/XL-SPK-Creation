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
public class Test_STR_Target_Import_CSV {
    static String str = 'NIK,Product_Family,Year,Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sept,Okt,Nov,Dec\n 90007527,GSM,2019,0,400000,500000,6000000,0,0,0,0,800000,1000000,1100000,2500000\n 90007527,Non-GSM,2019,0,400000,500000,6000000,0,0,0,0,800000,1000000,1100000,2500000';       

    public static String[] csvFileLines;
    public static Blob csvFileBody;

    static testmethod void testfileupload(){
        Test.startTest();       
        csvFileBody = Blob.valueOf(str);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n'); 

        STR_Target_Controller importData = new STR_Target_Controller();
        importData.csvFileBody = csvFileBody;
        importData.importCSVFile();
        importData.insertCSVFile();
        Test.stopTest();
    } 

    static testmethod void testfileuploadNegative(){
        Test.startTest();       
        csvFileBody = Blob.valueOf(str);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n'); 

        STR_Target_Controller importData = new STR_Target_Controller();
        importData.importCSVFile();
        Test.stopTest();
    }
}