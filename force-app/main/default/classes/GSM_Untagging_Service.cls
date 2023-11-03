public with sharing class GSM_Untagging_Service {
    
    public ID orderID;

    public boolean untaggingCheckNow;


    public GSM_Untagging_Service() {
        untaggingCheckNow = false;
    }

    
    public void untaggingRequestByOrder (ID orderID) {
        SYSTEM.DEBUG ('========== in GSM_Untagging_Service.untaggingRequestByOrder');
        
        integer recordLimit = integer.valueof(label.UnTagging_Max_Limit_Number);

        integer orderMSISDNCount = 0;
        integer sisa = 0;
        integer groupCount =0; 


        //* GET Group Counts -------------------------------------------------------------------------------
        List<Order_MSISDN__c> orderMSISDNList= [select id from Order_MSISDN__c where Order__c =:orderID];
        //* TODO: kasih kriteria hanya yang belum request untagging 



        orderMSISDNCount = orderMSISDNList.size();

        sisa = math.mod(orderMSISDNCount, recordLimit);
        groupCount =  orderMSISDNCount/ recordLimit;
        if (sisa>0) groupCount = groupCount + 1;



        //* GET last Execute Plan time -------------------------------------------------------------------------------
        List<Scheduled_Process__c> spList = [select id, Execute_Plan__c 
                                                from Scheduled_Process__c 
                                                where status__c = 'Waiting' 
                                                    and type__c = 'Callout GSMUnTagging' 
												order by Execute_Plan__c desc limit 1  ];
        Datetime nextSchedule =null;
        Datetime nextScheduleTmp =null;
        
        
        integer interval; //(in minute) -- 
        interval = integer.valueof( system.label.Batch_Tagging_Interval ); 
        
        if (spList.size() >0) {
            datetime dtmp = spList[0].Execute_Plan__c;
            nextScheduleTmp = dtmp.addMinutes(interval) ;
            if (nextScheduleTmp < system.now()) {
                nextSchedule = system.now().addMinutes(1);  
            } else {
                nextSchedule = nextScheduleTmp;
            }
        } else {
            //-- if no ongoing wating schedule process the Set TODAY (now)
            nextSchedule = system.now().addMinutes(1);
        }
        
        

        /**
         * create Scheduled_Process__c
         */


        String sYear;
        string sMonth;
        string sDay;
        string sHour;
        string sMinute;
        String sch ;
        String jobID ;
        string jobTitle;
        
        List<Scheduled_Process__c> spListTemp = new List<Scheduled_Process__c> ();
            
        for (Integer groupNo=1; groupNo <= groupCount; groupNo++)  {            
            /* 
            system.debug ('============ nextSchedule :' + nextSchedule);
            
            sYear = string.valueof( nextSchedule.year() );
            sMonth = string.valueof( nextSchedule.month() );
            sDay = string.valueof( nextSchedule.day() ); 
            sHour = string.valueof( nextSchedule.Hour() );
            sMinute = string.valueof( nextSchedule.minute() );
            
            Scheduled_Process_Services sps = new Scheduled_Process_Services();
            sps.jobType='Callout GSMUnTagging';   

            sch = '0 ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
            system.debug ('============ sch :' + sch);

            //-- create scheduler
            jobTitle = 'GSMUnTagging ' + sch + ' (orderID : ' +  orderID + '), Group No : ' + groupNo;
            jobID = system.schedule(jobTitle, sch, sps);
            */

            jobTitle = 'GSMUnTagging ' + sch + ' (orderID : ' +  orderID + '), Group No : ' + groupNo;

            //-- create schedule process (consist of information related to data tobe process, see on parameter2 )
            Scheduled_Process__c sp = new Scheduled_Process__c();
            sp.Execute_Plan__c = nextSchedule;
            sp.Type__c = 'Callout GSMUnTagging';
            sp.parameter1__c = orderID;
            sp.parameter2__c =  '{"group_no":' + groupNo + ', "data_limit":' + recordLimit + '}';  //--sample : {"group_no":1, "data_limit":2}
            sp.parameter3__c = jobID;
            sp.jobid__c = jobID;
            sp.order_related__c = orderID;            
            sp.title__c = jobTitle;  
            sp.notes1__c = 'Parameter1 = orderID; Parameter2 = Package Info; Parameter3 = JobID';

            if ( groupNo == groupCount ) sp.is_last_schedule_of_group__c = true;
            spListTemp.add(sp);
            
            nextSchedule= nextSchedule.addMinutes(interval) ;

        }
        SYSTEM.DEBUG ('========== spListTemp : ' + spListTemp);
        insert spListTemp;


        //-- create system.schedule
        Integer groupNo=1;
        for (Scheduled_Process__c sp : spListTemp ) {
            nextSchedule = sp.Execute_Plan__c;

            system.debug ('============ nextSchedule :' + nextSchedule);
            sYear = string.valueof( nextSchedule.year() );
            sMonth = string.valueof( nextSchedule.month() );
            sDay = string.valueof( nextSchedule.day() ); 
            sHour = string.valueof( nextSchedule.Hour() );
            sMinute = string.valueof( nextSchedule.minute() );
            
            Scheduled_Process_Services sps = new Scheduled_Process_Services();
            sps.jobType='Callout GSMUnTagging';   
            sps.scheduledProcessID = sp.id;  // <<-- this is the key

            sch = '0 ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
            system.debug ('============ sch :' + sch);

            //-- create scheduler
            jobTitle = 'GSMUnTagging ' + sch + ' (orderID : ' +  orderID + '), Group No : ' + groupNo;
            jobID = system.schedule(jobTitle, sch, sps);

            sp.jobid__c = jobID;
            sp.parameter3__c = jobID;
            sp.title__c = jobTitle;

            groupNo++;
        }
        SYSTEM.DEBUG ('========== spListTemp : ' + spListTemp);
        update spListTemp;

    }




    public void untaggingCheckRequestByUnTagRequest (ID scheduledProcessID) {
        SYSTEM.DEBUG ('========== in GSM_Untagging_Service.untaggingCheckRequestByUnTagRequest');
        
        integer recordLimit = integer.valueof(label.UnTaggingCheck_Max_Limit_Number);  // * test : 3

        integer spMSISDNCount = 0;
        integer sisa = 0;
        integer groupCount =0;


        Scheduled_Process__c spTag = [select id, request_id__c, order_related__c from Scheduled_Process__c where id =:scheduledProcessID];
        string requestID = spTag.request_id__c;
        string orderID = spTag.order_related__c;


        //* GET Group Counts -------------------------------------------------------------------------------
        List<SP_MSISDN__c> spMSISDNList= [select id from SP_MSISDN__c where Scheduled_Process__c =:scheduledProcessID];
        
        spMSISDNCount = spMSISDNList.size();

        sisa = math.mod(spMSISDNCount, recordLimit);
        groupCount =  spMSISDNCount/ recordLimit;
        if (sisa>0) groupCount = groupCount + 1;



        Datetime nextSchedule =null;
        Datetime nextScheduleTmp =null;

        integer interval; //(in minute) -- 
        interval = integer.valueof( system.label.Batch_UnTagging_Interval ); 

        //-jeda antara untagging dan checking 
        integer jeda = ((spMSISDNCount / 100 ) + 1 ) * 5 ; //( per 100 nomor dikali 5 menit)
        jeda = jeda +  2 ; //- tambah 2 menit

        //== untuk testing jeda = 1 menit //--todo: change this value
        //jeda = 1;

        //-- ini untuk kebutuhan mau check langsung tanpa ada jeda dari request untagging
        //-- baik digunakan untuk re-check jika sebelumnya ada masalah atau mungkin belum sepenuhnya selesai.
        if (untaggingCheckNow) {
            jeda = 1;
        }


        //-- * after  UNTAGGING is success ---
        nextSchedule = system.now().addMinutes(jeda);

        String sYear;
        string sMonth;
        string sDay;
        string sHour;
        string sMinute;
        String sch ;
        String jobID ;
        string jobTitle;
        
        List<Scheduled_Process__c> spListTemp = new List<Scheduled_Process__c> ();
            
        for (Integer groupNo=1; groupNo <= groupCount; groupNo++)  {            
            /*
            system.debug ('============ nextSchedule :' + nextSchedule);
            
            sYear = string.valueof( nextSchedule.year() );
            sMonth = string.valueof( nextSchedule.month() );
            sDay = string.valueof( nextSchedule.day() ); 
            sHour = string.valueof( nextSchedule.Hour() );
            sMinute = string.valueof( nextSchedule.minute() );
            
            Scheduled_Process_Services sps = new Scheduled_Process_Services();
            sps.jobType='Callout GSMUnTaggingCheck';   

            sch = '0 ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
            system.debug ('============ sch :' + sch);

            //-- create scheduler
            jobTitle = 'GSMUnTaggingCheck ' + sch + ' (Request ID : ' +  requestID + '), Group No : ' + groupNo;
            jobID = system.schedule(jobTitle, sch, sps);
            */

            jobTitle = 'GSMUnTaggingCheck ' + sch + ' (Request ID : ' +  requestID + '), Group No : ' + groupNo;
            
            //-- create schedule process (consist of information related to data tobe process, see on parameter2 )
            Scheduled_Process__c sp = new Scheduled_Process__c();
            sp.Execute_Plan__c = nextSchedule;
            sp.Type__c = 'Callout GSMUnTaggingCheck';
            sp.parameter1__c = scheduledProcessID;
            sp.parameter2__c =  '{"group_no":' + groupNo + ', "data_limit":' + recordLimit + '}';  //--sample : {"group_no":1, "data_limit":2}
            sp.parameter3__c = jobID;
            sp.jobid__c = jobID;
            sp.order_related__c = orderID;
            sp.scheduled_process_related__c = scheduledProcessID;            
            sp.title__c = jobTitle;  
            sp.request_id__c = requestID ;

            sp.notes1__c = 'Parameter1 = scheduledProcessID; Parameter2 = Package Info; Parameter3 = JobID';

            if ( groupNo == groupCount ) sp.is_last_schedule_of_group__c = true;
            spListTemp.add(sp);
            
            nextSchedule= nextSchedule.addMinutes(interval) ;

        }
        SYSTEM.DEBUG ('========== spListTemp : ' + spListTemp);
        insert spListTemp;



        //-- create system.schedule
        Integer groupNo=1;
        for (Scheduled_Process__c sp : spListTemp ) {
            nextSchedule = sp.Execute_Plan__c;

            system.debug ('============ nextSchedule :' + nextSchedule);
            sYear = string.valueof( nextSchedule.year() );
            sMonth = string.valueof( nextSchedule.month() );
            sDay = string.valueof( nextSchedule.day() ); 
            sHour = string.valueof( nextSchedule.Hour() );
            sMinute = string.valueof( nextSchedule.minute() );
            
            Scheduled_Process_Services sps = new Scheduled_Process_Services();
            sps.jobType='Callout GSMUnTaggingCheck';   
            sps.scheduledProcessID = sp.id;  // <<-- this is the key

            sch = '0 ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;
            system.debug ('============ sch :' + sch);

            //-- create scheduler
            jobTitle = 'GSMUnTaggingCheck ' + sch + ' (Request ID : ' +  requestID + '), Group No : ' + groupNo;
            jobID = system.schedule(jobTitle, sch, sps);

            sp.jobid__c = jobID;
            sp.title__c = jobTitle;
            sp.parameter3__c = jobID;

            groupNo++;
        }
        SYSTEM.DEBUG ('========== spListTemp : ' + spListTemp);
        update spListTemp;

    }



}