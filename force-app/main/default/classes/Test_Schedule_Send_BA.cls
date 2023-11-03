@isTest(seeAllData=true)
private  class Test_Schedule_Send_BA {


    static testMethod void doScenario1Test() {

        test.starttest();

        Schedule_Send_BA ssb = new Schedule_Send_BA();
        ssb.execute(null);


        test.stoptest();
    }

}