//Generated by wsdl2apex

public class sapComDocumentSapSoapFunctionsMcS3 {
    public class ZexdSfChangeStatusResponse_element {
        public sapComDocumentSapSoapFunctionsMcS3.Zexdsdtt00059 FeReturn;
        private String[] FeReturn_type_info = new String[]{'FeReturn','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'FeReturn'};
    }
    public class Zexdsdtt00059 {
        public sapComDocumentSapSoapFunctionsMcS3.Zexdsdst00115[] item;
        private String[] item_type_info = new String[]{'item','urn:sap-com:document:sap:soap:functions:mc-style',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class ZexdSfChangeStatus_element {
        public sapComDocumentSapSoapFunctionsMcS3.Zexdsdst00116 FiTransactionData;
        private String[] FiTransactionData_type_info = new String[]{'FiTransactionData','urn:sap-com:document:sap:soap:functions:mc-style',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'FiTransactionData'};
    }
    public class Zexdsdst00116 {
        public String SapId;
        public String Status;
        public String Source;
        private String[] SapId_type_info = new String[]{'SapId','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] Status_type_info = new String[]{'Status','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] Source_type_info = new String[]{'Source','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'SapId','Status','Source'};
    }
    public class Zexdsdst00115 {
        public String SapId;
        public String Status;
        public String IsError;
        public String Messages;
        private String[] SapId_type_info = new String[]{'SapId','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] Status_type_info = new String[]{'Status','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] IsError_type_info = new String[]{'IsError','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] Messages_type_info = new String[]{'Messages','urn:sap-com:document:sap:soap:functions:mc-style',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style','false','true'};
        private String[] field_order_type_info = new String[]{'SapId','Status','IsError','Messages'};
    }
    public class ZBIND_SF_NOTIF_CHANGESTATUS {
        //public String endpoint_x = 'https://e-suppliermgmt.xl.co.id:5555/sap/bc/srt/rfc/sap/zws_sf_notif_changestatus/088/zsrv_sf_notif_changestatus/zbind_sf_notif_changestatus';
        public String endpoint_x = 'https://e-suppliermgmt.xl.co.id:7777/sap/bc/srt/rfc/sap/zws_sf_notif_changestatus/088/zsrv_sf_notif_changestatus/zbind_sf_notif_changestatus';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'urn:sap-com:document:sap:soap:functions:mc-style', 'sapComDocumentSapSoapFunctionsMcS3', 'urn:sap-com:document:sap:rfc:functions', 'sapComDocumentSapRfcFunctions3'};
        public sapComDocumentSapSoapFunctionsMcS3.Zexdsdtt00059 ZexdSfChangeStatus(sapComDocumentSapSoapFunctionsMcS3.Zexdsdst00116 FiTransactionData) {
            sapComDocumentSapSoapFunctionsMcS3.ZexdSfChangeStatus_element request_x = new sapComDocumentSapSoapFunctionsMcS3.ZexdSfChangeStatus_element();
            request_x.FiTransactionData = FiTransactionData;
            sapComDocumentSapSoapFunctionsMcS3.ZexdSfChangeStatusResponse_element response_x;
            Map<String, sapComDocumentSapSoapFunctionsMcS3.ZexdSfChangeStatusResponse_element> response_map_x = new Map<String, sapComDocumentSapSoapFunctionsMcS3.ZexdSfChangeStatusResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'urn:sap-com:document:sap:soap:functions:mc-style:ZWS_SF_NOTIF_CHANGESTATUS:ZexdSfChangeStatusRequest',
              'urn:sap-com:document:sap:soap:functions:mc-style',
              'ZexdSfChangeStatus',
              'urn:sap-com:document:sap:soap:functions:mc-style',
              'ZexdSfChangeStatusResponse',
              'sapComDocumentSapSoapFunctionsMcS3.ZexdSfChangeStatusResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.FeReturn;
        }
    }
}