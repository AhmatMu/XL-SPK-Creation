@isTest
public class TEST_Call_REST_BAP_EndofContract_Schdler {

    @isTest
    static void EmailMethod_1(){
        Id recordTypeId_bapEndofContract = Schema.SObjectType.BAP__c.getRecordTypeInfosByName().get('End of Contract').getRecordTypeId();
        BAP__c bap = new BAP__c();
        bap.RecordTypeId = recordTypeId_bapEndofContract;
        bap.type_of_request__c ='Pemutusan'; 
        bap.customer__c ='0017F00000RM04mQAD';
        bap.Link__c= 'a077F000003X0ZFQA0' ; //'a077F000003X0ILQA0'; //'a077F000003WzDrQAK' 
        bap.sirkit__c='testbro';
        bap.Address2__c ='jl.cenrawasih';
        bap.pic_name__c ='do';
        bap.pic_phone__c ='de';
        bap.pic_position__c='PIC UP Invoice;PIC CS,';
        bap.pic_email__c='do@gmail.com';
        bap.bandwidth__c=3;
        bap.Bandwidth_UOM__c='Mbps';
        bap.request_date__c=date.newInstance(2018, 4, 21);
        bap.terminate_date__c = date.newInstance(2018, 5, 21);
        bap.reason__c ='Kontrak berakhir atau tidak diperpanjang';
        bap.note__C ='note';
        bap.bap_status__c='approved';
        bap.approval_status__c = 'Need GM Sales Approval';
        bap.approval_iom__c = '';
        bap.remark__c ='remark';
        bap.request_status__C='Draft';
        insert bap;
        
        bap.Request_Status__c = 'Submit';
        update bap;
        string bapid; string typeOfRequest; string customer; string cid; string sirkit; string address;
        string pic; string picPhone; string picEmail; string picPosition; string bandwidth;
        string bandwidthUom; string requestDate; string terminateDate; string reason; 
        string note; string userCreate ; string request_status; string iom_file_link; string termination_for_nonautorenewal;
    
        integer approveType ;
        string approveEmail;
        string approveDate;

        bapid = bap.BAP_ID__c;
        typeOfRequest = bap.Type_of_Request__c;
        customer = bap.Customer__c;
        cid = bap.CID__c;
        sirkit = bap.Sirkit__c;
        address = bap.Address2__c;
        pic = bap.PIC_Name__c;
        picPhone = bap.PIC_Phone__c; 
        picEmail = bap.PIC_email__c;
        picPosition = bap.PIC_Position__c;
        if (!String.isBlank(picPosition)) {
            picPosition = picPosition.replace(';',',');
        }

        bandwidth = bap.Bandwidth_rel__c;
        bandwidthUom = bap.UoM_rel__c;
        
        bap.Request_Date__c = system.today();
        
        Date d = bap.Request_Date__c;
        Datetime dt = datetime.newInstance(d.year(), d.month(),d.day());
        requestDate = dt.format ('yyyy-MM-dd') ; 
        
        d = bap.Terminate_Date__c;
        dt = datetime.newInstance(d.year(), d.month(),d.day());
        terminateDate = dt.format('yyyy-MM-dd');
        
        reason = bap.Reason__c;
        note = bap.Note__c;
        userCreate = bap.CreatedBy_email__C;
        iom_file_link = null;

        if (bapid <> '' && bapid <> null) {
            request_status = 'Operation Review';    //-- for re-SUBMIT and update BAP
        } else {
            request_status = null; 
        }
        
        termination_for_nonautorenewal= 'true';


        Datetime nextSchedule = system.now().addSeconds(3);

        String hour = String.valueOf( nextSchedule.hour());
        String min = String.valueOf( nextSchedule.minute()); 
        String ss = String.valueOf( nextSchedule.second());
        String sDay = string.valueof( nextSchedule.day() ); 
        String sYear = string.valueof( nextSchedule.year() );
        String sMonth = string.valueof( nextSchedule.month() );
        
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;

        Call_REST_BAP_EndofContract_Schdler Call_REST_BAP_EndofContract = new Call_REST_BAP_EndofContract_Schdler(bap.id, bapid,
        typeOfRequest, customer, cid, sirkit, address,
        pic, picPhone, picEmail, picPosition, bandwidth,
        bandwidthUom, requestDate, terminateDate, reason, 
        note, userCreate , request_status , iom_file_link, termination_for_nonautorenewal  ); 
        System.schedule('Call_REST_BAP_EndofContract_Schdler ' + String.valueOf(system.now()), nextFireTime, Call_REST_BAP_EndofContract);
    }

}