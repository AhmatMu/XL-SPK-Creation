global class Call_REST_BAP_EndofContract_Schdler implements Schedulable{
    Public string recordId;
    Public string bapid;
    Public string typeOfRequest;
    Public string customer;
    Public string cid;
    Public string sirkit;
    Public string address;
    Public string pic;
    Public string picPhone;
    Public string picEmail;
    Public string picPosition;
    Public string bandwidth;
    Public string bandwidthUom;
    Public string requestDate;
    Public string terminateDate;
    Public string reason; 
    Public string note;
    Public string userCreate;
    Public string request_status;
    Public string iom_file_link;
    Public string termination_for_nonautorenewal;

    global Call_REST_BAP_EndofContract_Schdler(
        String arecordId,
        String abapid, 
        String atypeOfRequest, 
        String acustomer, 
        String acid, 
        String asirkit, 
        String aaddress, 
        String apic, 
        String apicPhone, 
        String apicEmail, 
        String apicPosition, 
        String abandwidth, 
        String abandwidthUom, 
        String arequestDate, 
        String aterminateDate, 
        String areason, 
        String anote,
        String auserCreate,
        String arequest_status,
        String aiom_file_link,
        String atermination_for_nonautorenewal
        ){
        recordId = arecordId;
        bapid = abapid;
        typeOfRequest = atypeOfRequest;
        customer = acustomer;
        cid = acid;
        sirkit = asirkit;
        address = aaddress;
        pic = apic;
        picPhone = apicPhone;
        picEmail = apicEmail;
        picPosition = apicPosition;
        bandwidth = abandwidth;
        bandwidthUom = abandwidthUom;
        requestDate = arequestDate;
        terminateDate = aterminateDate;
        reason = areason;
        note = anote;
        userCreate = auserCreate;
        request_status = arequest_status;
        iom_file_link = aiom_file_link;
        termination_for_nonautorenewal = atermination_for_nonautorenewal;
    }
    
    global void execute(SchedulableContext sc){
        testScheduleClassMethod(
            recordId,
            bapid,
            typeOfRequest,
            customer,
            cid,
            sirkit,
            address,
            pic,
            picPhone,
            picEmail,
            picPosition,
            bandwidth,
            bandwidthUom,
            requestDate,
            terminateDate,
            reason,
            note,
            userCreate,
            request_status,
            iom_file_link,
            termination_for_nonautorenewal
        );
    }

    global void testScheduleClassMethod(
        String arecordId,
        String abapid, 
        String atypeOfRequest, 
        String acustomer, 
        String acid, 
        String asirkit, 
        String aaddress, 
        String apic, 
        String apicPhone, 
        String apicEmail, 
        String apicPosition, 
        String abandwidth, 
        String abandwidthUom, 
        String arequestDate, 
        String aterminateDate, 
        String areason, 
        String anote,
        String auserCreate,
        String arequest_status,
        String aiom_file_link,
        String atermination_for_nonautorenewal
    ){
        REST_BAPs_v2.mirroringBAP(
            arecordId,
            abapid, 
            atypeOfRequest, 
            acustomer, 
            acid, 
            asirkit, 
            aaddress, 
            apic, 
            apicPhone, 
            apicEmail, 
            apicPosition, 
            abandwidth, 
            abandwidthUom, 
            arequestDate, 
            aterminateDate, 
            areason, 
            anote,
            auserCreate,
            arequest_status,
            aiom_file_link,
            atermination_for_nonautorenewal           
        ); 
    }
}