//Generated by wsdl2apex

public class sapComDocumentSapRfcFunctions2 {
    public class ZEXDSDST00100 {
        public String ROLE;
        public String PARTNER_ID;
        public String PARTNER_NAME;
        private String[] ROLE_type_info = new String[]{'ROLE','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] PARTNER_ID_type_info = new String[]{'PARTNER_ID','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] PARTNER_NAME_type_info = new String[]{'PARTNER_NAME','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:rfc:functions','false','true'};
        private String[] field_order_type_info = new String[]{'ROLE','PARTNER_ID','PARTNER_NAME'};
    }
    public class ZEXDSDST00101 {
        public String TRANSACTION_ID;
        public String SAP_ID;
        public String CID;
        public String STATUS;
        public String IS_ERROR;
        public sapComDocumentSapRfcFunctions2.ZEXDSDTT00052 MESSAGES;
        private String[] TRANSACTION_ID_type_info = new String[]{'TRANSACTION_ID','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] SAP_ID_type_info = new String[]{'SAP_ID','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] CID_type_info = new String[]{'CID','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] STATUS_type_info = new String[]{'STATUS','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] IS_ERROR_type_info = new String[]{'IS_ERROR','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] MESSAGES_type_info = new String[]{'MESSAGES','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:rfc:functions','false','true'};
        private String[] field_order_type_info = new String[]{'TRANSACTION_ID','SAP_ID','CID','STATUS','IS_ERROR','MESSAGES'};
    }
    public class ZEXD_SF_SRPRResponse_element {
        public sapComDocumentSapRfcFunctions2.ZEXDSDTT00054 FE_RETURN;
        private String[] FE_RETURN_type_info = new String[]{'FE_RETURN','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:rfc:functions','false','true'};
        private String[] field_order_type_info = new String[]{'FE_RETURN'};
    }
    public class ZEXDSDTT00053 {
        public sapComDocumentSapRfcFunctions2.ZEXDSDST00100[] item;
        private String[] item_type_info = new String[]{'item','urn:sap-com:document:sap:rfc:functions',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:rfc:functions','false','true'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class ZEXDSDTT00054 {
        public sapComDocumentSapRfcFunctions2.ZEXDSDST00101[] item;
        private String[] item_type_info = new String[]{'item','urn:sap-com:document:sap:rfc:functions',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:rfc:functions','false','true'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class ZEXD_SF_SRPR_element {
        public sapComDocumentSapRfcFunctions2.ZEXDSDTT00053 FI_PARTNER_TAB;
        public sapComDocumentSapRfcFunctions2.ZEXDSDST00099 FI_TECH_INFO;
        public sapComDocumentSapRfcFunctions2.ZEXDSDST00098 FI_TRANSACTION_DATA;
        private String[] FI_PARTNER_TAB_type_info = new String[]{'FI_PARTNER_TAB','urn:sap-com:document:sap:rfc:functions',null,'0','1','false'};
        private String[] FI_TECH_INFO_type_info = new String[]{'FI_TECH_INFO','urn:sap-com:document:sap:rfc:functions',null,'0','1','false'};
        private String[] FI_TRANSACTION_DATA_type_info = new String[]{'FI_TRANSACTION_DATA','urn:sap-com:document:sap:rfc:functions',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:rfc:functions','false','true'};
        private String[] field_order_type_info = new String[]{'FI_PARTNER_TAB','FI_TECH_INFO','FI_TRANSACTION_DATA'};
    }
    public class ZEXDSDTT00052 {
        public sapComDocumentSapRfcFunctions2.ZEXDSDST00097[] item;
        private String[] item_type_info = new String[]{'item','urn:sap-com:document:sap:rfc:functions',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:rfc:functions','false','true'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class ZEXDSDST00097 {
        public String MESSAGE_NO;
        public String MESSAGE;
        private String[] MESSAGE_NO_type_info = new String[]{'MESSAGE_NO','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] MESSAGE_type_info = new String[]{'MESSAGE','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:rfc:functions','false','true'};
        private String[] field_order_type_info = new String[]{'MESSAGE_NO','MESSAGE'};
    }
    public class ZEXDSDST00098 {
        public String TASK;
        public String TRANSACTION_DATE;
        public String TRANSACTION_ID;
        public String OPPORTUNITY_ID;
        public String TRX_TYPE;
        public String SAP_ID;
        public String SR_NO;
        public String PROJECT_TYPE;
        private String[] TASK_type_info = new String[]{'TASK','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] TRANSACTION_DATE_type_info = new String[]{'TRANSACTION_DATE','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] TRANSACTION_ID_type_info = new String[]{'TRANSACTION_ID','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] OPPORTUNITY_ID_type_info = new String[]{'OPPORTUNITY_ID','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] TRX_TYPE_type_info = new String[]{'TRX_TYPE','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] SAP_ID_type_info = new String[]{'SAP_ID','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] SR_NO_type_info = new String[]{'SR_NO','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] PROJECT_TYPE_type_info = new String[]{'PROJECT_TYPE','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:rfc:functions','false','true'};
        private String[] field_order_type_info = new String[]{'TASK','TRANSACTION_DATE','TRANSACTION_ID','OPPORTUNITY_ID','TRX_TYPE','SAP_ID','SR_NO','PROJECT_TYPE'};
    }
    public class ZEXDSDST00099 {
        public String PRODUCT;
        public String EXPECTED_RFS_DAT;
        public String CONTRACT_PERIODE;
        public String PERIODE_UOM;
        public String BANDWIDTH;
        public String UOM_BANDWIDTH;
        public String BANDWIDTH_BEFORE;
        public String INTERNATIONAL_BW;
        public String LOCAL_BW;
        public String QUOTA;
        public String UOM_QUOTA;
        public String ROUTER_TYPE;
        public String QOS;
        public String AS_NUMBER;
        public String PSTN_DOMESTIC;
        public String MOBILE_DOMESTIC;
        public String XL_ON_NET;
        public String ROUNDED_TIME;
        public String PLACE_COL;
        public String POWER_CONSUMPTION;
        public String RACK_QUANTITY;
        public String MAIL_HOSTING;
        public String USER_QTY;
        public String DOMAIN;
        public String ADD_ON_STORAGE;
        public String OS;
        public String CORE;
        public String RAM;
        public String STORAGE;
        public String SEGMENT;
        public String SM_NAME;
        public String CID;
        public String LINKID;
        public String LAST_MILE;
        public String RESERVE1;
        public String RESERVE2;
        public String ADDR_RELOC_A;
        public String ADDR_RELOC_B;
        private String[] PRODUCT_type_info = new String[]{'PRODUCT','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] EXPECTED_RFS_DAT_type_info = new String[]{'EXPECTED_RFS_DAT','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] CONTRACT_PERIODE_type_info = new String[]{'CONTRACT_PERIODE','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] PERIODE_UOM_type_info = new String[]{'PERIODE_UOM','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] BANDWIDTH_type_info = new String[]{'BANDWIDTH','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] UOM_BANDWIDTH_type_info = new String[]{'UOM_BANDWIDTH','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] BANDWIDTH_BEFORE_type_info = new String[]{'BANDWIDTH_BEFORE','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] INTERNATIONAL_BW_type_info = new String[]{'INTERNATIONAL_BW','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] LOCAL_BW_type_info = new String[]{'LOCAL_BW','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] QUOTA_type_info = new String[]{'QUOTA','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] UOM_QUOTA_type_info = new String[]{'UOM_QUOTA','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] ROUTER_TYPE_type_info = new String[]{'ROUTER_TYPE','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] QOS_type_info = new String[]{'QOS','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] AS_NUMBER_type_info = new String[]{'AS_NUMBER','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] PSTN_DOMESTIC_type_info = new String[]{'PSTN_DOMESTIC','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] MOBILE_DOMESTIC_type_info = new String[]{'MOBILE_DOMESTIC','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] XL_ON_NET_type_info = new String[]{'XL_ON_NET','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] ROUNDED_TIME_type_info = new String[]{'ROUNDED_TIME','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] PLACE_COL_type_info = new String[]{'PLACE_COL','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] POWER_CONSUMPTION_type_info = new String[]{'POWER_CONSUMPTION','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] RACK_QUANTITY_type_info = new String[]{'RACK_QUANTITY','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] MAIL_HOSTING_type_info = new String[]{'MAIL_HOSTING','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] USER_QTY_type_info = new String[]{'USER_QTY','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] DOMAIN_type_info = new String[]{'DOMAIN','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] ADD_ON_STORAGE_type_info = new String[]{'ADD_ON_STORAGE','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] OS_type_info = new String[]{'OS','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] CORE_type_info = new String[]{'CORE','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] RAM_type_info = new String[]{'RAM','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] STORAGE_type_info = new String[]{'STORAGE','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] SEGMENT_type_info = new String[]{'SEGMENT','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] SM_NAME_type_info = new String[]{'SM_NAME','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] CID_type_info = new String[]{'CID','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] LINKID_type_info = new String[]{'LINKID','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] LAST_MILE_type_info = new String[]{'LAST_MILE','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] RESERVE1_type_info = new String[]{'RESERVE1','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] RESERVE2_type_info = new String[]{'RESERVE2','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] ADDR_RELOC_A_type_info = new String[]{'ADDR_RELOC_A','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] ADDR_RELOC_B_type_info = new String[]{'ADDR_RELOC_B','urn:sap-com:document:sap:rfc:functions',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:sap-com:document:sap:rfc:functions','false','true'};
        private String[] field_order_type_info = new String[]{'PRODUCT','EXPECTED_RFS_DAT','CONTRACT_PERIODE','PERIODE_UOM','BANDWIDTH','UOM_BANDWIDTH','BANDWIDTH_BEFORE','INTERNATIONAL_BW','LOCAL_BW','QUOTA','UOM_QUOTA','ROUTER_TYPE','QOS','AS_NUMBER','PSTN_DOMESTIC','MOBILE_DOMESTIC','XL_ON_NET','ROUNDED_TIME','PLACE_COL','POWER_CONSUMPTION','RACK_QUANTITY','MAIL_HOSTING','USER_QTY','DOMAIN','ADD_ON_STORAGE','OS','CORE','RAM','STORAGE','SEGMENT','SM_NAME','CID','LINKID','LAST_MILE','RESERVE1','RESERVE2','ADDR_RELOC_A','ADDR_RELOC_B'};
    }
    public class ZBD_SF_SRPR {
        public String endpoint_x =system.label.URL_SAP_SR_PR; // 'https://e-suppliermgmt.xl.co.id:5555/sap/bc/srt/rfc/sap/zws_sf_srpr/088/zsr_sf_srpr/zbd_sf_srpr';
  //      public String endpoint_x ='https://e-suppliermgmt.xl.co.id:7777/sap/bc/srt/rfc/sap/zws_sf_srpr/088/zsr_sf_srpr/zbd_sf_srpr';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x=120000;
        private String[] ns_map_type_info = new String[]{'urn:sap-com:document:sap:rfc:functions', 'sapComDocumentSapRfcFunctions2'};
        public sapComDocumentSapRfcFunctions2.ZEXDSDTT00054 ZEXD_SF_SRPR(sapComDocumentSapRfcFunctions2.ZEXDSDTT00053 FI_PARTNER_TAB,sapComDocumentSapRfcFunctions2.ZEXDSDST00099 FI_TECH_INFO,sapComDocumentSapRfcFunctions2.ZEXDSDST00098 FI_TRANSACTION_DATA) {
            sapComDocumentSapRfcFunctions2.ZEXD_SF_SRPR_element request_x = new sapComDocumentSapRfcFunctions2.ZEXD_SF_SRPR_element();
            request_x.FI_PARTNER_TAB = FI_PARTNER_TAB;
            request_x.FI_TECH_INFO = FI_TECH_INFO;
            request_x.FI_TRANSACTION_DATA = FI_TRANSACTION_DATA;
            sapComDocumentSapRfcFunctions2.ZEXD_SF_SRPRResponse_element response_x;
            Map<String, sapComDocumentSapRfcFunctions2.ZEXD_SF_SRPRResponse_element> response_map_x = new Map<String, sapComDocumentSapRfcFunctions2.ZEXD_SF_SRPRResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'urn:sap-com:document:sap:rfc:functions:ZWS_SF_SRPR:ZEXD_SF_SRPRRequest',
              'urn:sap-com:document:sap:rfc:functions',
              'ZEXD_SF_SRPR',
              'urn:sap-com:document:sap:rfc:functions',
              'ZEXD_SF_SRPRResponse',
              'sapComDocumentSapRfcFunctions2.ZEXD_SF_SRPRResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.FE_RETURN;
        }
    }
}