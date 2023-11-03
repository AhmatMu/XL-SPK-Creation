trigger Trigger_Scheduled_Process on Scheduled_Process__c (after insert, after update) {

    //-- TODO : add label for ON OFF
    // if (label.Is_Trigger_Scheduled_Process_ON == 'YES') {

        //-- INSERT
        if(trigger.isInsert){
        
            //-- AFTER INSERT
        	if(trigger.isAfter) {

                List<SP_MSISDN__c> spMSISDNList = new List<SP_MSISDN__c>();

                for(Scheduled_Process__c newSP:system.trigger.new) {    
                    if (newSP.type__c == 'Callout GSMTagging' || newSP.type__c == 'Callout GSMUnTagging') {
                        //-- insert data msisdn in object SP_MSISDN__c
                        
                        string orderID = newSP.Parameter1__c;
                        Data_Filter df = (Data_Filter) JSON.deserialize(newSP.Parameter2__c, Data_Filter.class);
                        integer dataLimit = df.data_limit;
                        integer groupNo = df.group_no;
                        integer dataOffset = (groupNo -1 )* dataLimit;

                        // *-- TODO: need to good implemetation related to max SOQL in loop (100x)
                        List<Order_MSISDN__c> orderMSISDNList = [ SELECT id, name, order__r.ID_COM_Number__c, order__r.COMTYPE__c  
                                                            FROM Order_MSISDN__c 
                                                            WHERE order__c =: orderid 
                                                            //AND PC_Notes__c = 'test'
                                                            order by createddate, id 
                                                            limit :dataLimit
                                                            offset :dataOffset]; 


                        string scheduledProcessID = newSP.id;
                        
                        if ( orderMSISDNList.size() > 0 ) {
                            for (integer temp=0; temp<orderMSISDNList.size(); temp++){
                                SP_MSISDN__c tmpSPMISISDN = new SP_MSISDN__c();
                                tmpSPMISISDN.name= orderMSISDNList[temp].name;
                                tmpSPMISISDN.Order_MSISDN__c = orderMSISDNList[temp].id;
                                tmpSPMISISDN.Scheduled_Process__c = scheduledProcessID;
                                spMSISDNList.add(tmpSPMISISDN);
                        
                            }
                        }


                    }

                }

                if (spMSISDNList.size() >0 ) 
                    // *-- TODO: implement Try and Catch
                    insert spMSISDNList;


            }
        
        }



        


        //-- UPDATE 
        if(trigger.isupdate){
            
            //-- before UPDATE
            //if(trigger.isbefore) {
                
            //}

			//-- AFTER UPDATE
        	if(trigger.isAfter) {
                for(Scheduled_Process__c newSP:system.trigger.new) {
                    Scheduled_Process__c oldSP=Trigger.oldMap.get(newSP.id);

                    if (newSP.status__c=='Success' && oldSP.status__c!='Success' ) {
                        if (newSP.type__c == 'Callout GSMTagging') {
                            //* CREATE scheduled_process each tag-check-package
                            //UPDATE 24/8/2022
                            //Proses Checking sudah tidak digunakan
                            //Hasil proses tagging akan dilakukan oleh API Community
                            /*
                            GSM_Tagging_Service gts = new GSM_Tagging_Service();
                            gts.taggingCheckRequestByTagRequest(newSP.id);
							*/
                        }
                        else if (newSP.type__c == 'Callout GSMUnTagging') {
                            //* CREATE scheduled_process each untag-check-package
                            GSM_UnTagging_Service guts = new GSM_UnTagging_Service();
                            guts.untaggingCheckRequestByUnTagRequest(newSP.id);
                        }
                    }

                    else if (newSP.status__c=='Failed' && oldSP.status__c!='Failed'  ) {
                        if (newSP.type__c == 'Callout GSMTagging' || newSP.type__c == 'Callout GSMUnTagging') {

                            if ( newSP.is_Last_Schedule_of_Group__c == true ) {
                                //-- jika scheduled process failed dan last schedule, then send email to ...
                                string orderID = newSP.Parameter1__c; 
                                List <Order> orderList = [select id, sub_status__c From order where id = :orderID];
                                if (orderList.size() > 0) {
                                    orderList[0].sub_status__c = 'Something Failed';  // <-- the changes will be trigger to send an email notification  
                                }
                            }
                        }


                    }
                
                }
                
            }

        }


    //}


    class Data_Filter {
        integer group_no;
        integer data_limit;
    }


}