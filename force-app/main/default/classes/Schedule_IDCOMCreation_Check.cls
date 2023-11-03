global class Schedule_IDCOMCreation_Check implements Schedulable{ 
    /*
    global Schedule_IDCOMCreation_Check() {

    }*/
    global void execute(SchedulableContext sc){
        string COMCODE = '';
        string orderID = '';
        string cronTriggerScheduledID =null;

        string responseStatus ='';
        string errMessage ='';

        List<Order> orderList = [select id, name, ID_COM_Number__c , status from order where status='CREATE ID COM' order by createddate desc limit 50];
        for (Order orderObj : orderList) {

            //-- check
            COMCODE = orderObj.ID_COM_Number__c; 
            orderID = orderObj.id;
            if (sc <> null)
                cronTriggerScheduledID = sc.getTriggerId();


            //REST_Community objRESTCommunity = new REST_Community();
            if (!test.isRunningTest())
                REST_Community_Callout.checkCommFromScheduler(COMCODE, orderID, cronTriggerScheduledID);
            /*
            if (responseStatus=='available') {
                //comcodeAvabilityInfo = 'COMCODE has been used, please choose another comcode.' ; //+ objRESTCommunity.responseMessage;

                //-- move stage to tagging process
                orderObj.status = 'Tagging Process';
            }
            */
        }
        system.debug ('===== orderList : ' +  orderList);

        /*
        try {
            if (orderList.size() > 0  ) {
                update orderList;
            }
        } catch (Exception e) {
            errMessage =  e.getmessage() + ' ' + e.getstacktraceString() ; appUtils.putError('Error on Schedule_IDCOMCreation_Check ::' + errMessage + '::' + e.getLineNumber()  ); 
            system.debug ('===== errMessage : ' +  errMessage);
        } */

    }
}