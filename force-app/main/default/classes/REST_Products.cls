@RestResource(urlMapping='/products/*')
global with sharing class REST_Products {

    class Header {
        string service='';
        string request_id ='';
        string response_id='';
        string status ='';
    }
    
    class DataProduct {
        string product_sfid = '';
    }

    class Except {
        string error_code='';
        string error_message = '';
    }
    
    class Body {
        Except except; 
        DataProduct data; 
        
        Body () {
           data  = new DataProduct();
           except = new Except();
        }
    }
    
    global class RESTResult{
        Header header;
        Body body;        
        RESTResult(){
            header= new Header();
            body= new Body();
        }
    }
    
    
    
/*    
    @HttpGet

    global static RESTResultX doGet(){
        
        RESTResultX restResult = new RESTResultX('', ''); 
        return restResult ;
    }
*/    

    /*
     * THIS METHOD FOR ADD/INSERT NEW PRODUCT 
     *
     */
    @HttpPost
    global static RESTResult doPost(){
        String param ='';
        String status ='';
        String service ='';
        String requestid ='';
        String errMessage ='-';
        String errCode ='-';
        
        String ipAddressRequestCameFrom='';
        String currentRequestURL;
        String sfdcBaseURL;        

        String uniqueNumber;
        
        string productSFID;
        string productCode ;
        string productName ;
        string sapCode  ;
        string productDescription  ;
        string productFamily  ;
        string gsmType  ;
        string simType  ;
        string chargeType  ;
        string standardPrice  ;
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callin';
        calllog.method__c = 'POST';
        calllog.request_start_time__c = datetime.now();
    
        List<Product2> tmpProducts = new List <Product2>(); 
        try  {
                RestRequest request = RestContext.request;
                //RestResponse response = RestContext.response;
                param = RestContext.request.requestBody.toString().trim();
                status ='success';
                
                // put callout information
                calllog.request_message__c = param ;
                calllog.response_message__c = status;
                calllog.status__c = status ;
                calllog.uri__c = request.requestURI;
                
                ipAddressRequestCameFrom = request.remoteAddress;
                system.debug ('============= ipAddressRequestCameFrom : ' + ipAddressRequestCameFrom );
                system.debug ('============= request.headers          : ' + request.headers);
                system.debug ('============= request.httpMethod       : ' + request.httpMethod);
                system.debug ('============= request.params           : ' + request.params);
                system.debug ('============= request.remoteAddress    : ' + request.remoteAddress);
                system.debug ('============= request.requestBody      : ' + request.requestBody);
                system.debug ('============= request.requestURI       : ' + request.requestURI);
                system.debug ('============= request.resourcePath     : ' + request.resourcePath);
                
                // Get the base URL.
                sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                System.debug('Base URL: ' + sfdcBaseURL );       
                
                // Get the URL for the current request.
                currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
                System.debug('Current request URL: ' + currentRequestURL); 
                
                calllog.callerFrom__c = ipAddressRequestCameFrom ;
                calllog.endpoint__c = currentRequestURL.replace (calllog.uri__c,'');                
                
                
                /* -- MAIN PROCESS -- */
                 
                Map<String, Object> paramMap = (Map<String, Object>) JSON.deserializeUntyped(param);
                system.debug('============ paramMap  : ' + paramMap );
                
                if(paramMap.size() > 0){   
                   Map<string, Object> mapRec = (Map<string, Object>) appUtils.getObjectDataOnMap(paramMap,'body::data');
 
                   requestid = AppUtils.getStringDataOnMap(paramMap , 'header::request_id');
                   service = AppUtils.getStringDataOnMap(paramMap , 'header::service');

                    if (service != 'addproduct') {
                        // the service is NOT RELEVANT
                        status = 'failed';
                        errMessage = 'The service is not relevant.';
                        errCode = '1';

                    } else {
                        // Get Product Record data
                        productCode = AppUtils.getStringDataOnMap(mapRec , 'product_code');
                        productFamily = AppUtils.getStringDataOnMap(mapRec , 'product_family');
                        System.debug(' ============ SQL : SELECT id FROM product2 WHERE productcode = ' + productCode);
                        if (! (AppUtils.isKeysetNotFound(productCode) || productCode=='' ) ){
                                tmpProducts = [SELECT id FROM product2 WHERE productcode = :productCode and family=:productFamily LIMIT 1 ];
                                system.debug('============ tmpProducts : ' + tmpProducts);
                                
                                if (tmpProducts.size() >0){
                                    status = 'failed';
                                    errMessage = 'Cannot add the data, the ID for ' + productFamily +' is already exists in the system.';
                                }
                        } 
                    }

                    // IF STATUS is NOT FAILED
                    if (status<>'failed') {
                        // if using list data :
                        // List <Object> objList = (List<Object>) appUtils.getListDataOnMap(paramMap,'body::data');
                   //for (Object oo : objList) {
                       //Map<string, Object> mapRec = (Map<string, Object>) oo;
                       

                        Product2 oProduct = new Product2 ();       
                        List <Product2> listProduct = new List <Product2>();                
                       
                        productCode = AppUtils.getStringDataOnMap(mapRec , 'product_code');
                        productName = AppUtils.getStringDataOnMap(mapRec , 'product_name');
                        sapCode = AppUtils.getStringDataOnMap(mapRec , 'sap_code');
                        productDescription = AppUtils.getStringDataOnMap(mapRec , 'product_description');
                        productFamily = AppUtils.getStringDataOnMap(mapRec , 'product_family');
                        gsmType = AppUtils.getStringDataOnMap(mapRec , 'gsm_type');
                        simType = AppUtils.getStringDataOnMap(mapRec , 'sim_type');
                        chargeType = AppUtils.getStringDataOnMap(mapRec , 'charge_type');
                        standardPrice = AppUtils.getStringDataOnMap(mapRec , 'standard_price');

                       //TODO: handle for KEYSET NOT FOUND - DONE
                       //TODO: setup Opportunity that used the CID that inserted 
                       //TODO: handling for partial error on dataset (one of data list) 
                       if (AppUtils.isKeysetNotFound(productCode) || productCode=='' ) {
                           // CID not found or empty
                           status = 'failed';
                           errMessage = 'Product Code not found on the data. ';
                           errCode = '1';
                       } 

                       if (status != 'failed') {
                           oProduct.ProductCode=  AppUtils.isKeysetNotFound(productCode) ? null : productCode;  
                           oProduct.Name=  AppUtils.isKeysetNotFound(productName) ? null : productName;  
                           oProduct.SAP_Code__c=  AppUtils.isKeysetNotFound(sapCode) ? null : sapCode;  
                           oProduct.description=  AppUtils.isKeysetNotFound(productDescription) ? null : productDescription;  
                           oProduct.Family=  AppUtils.isKeysetNotFound(productFamily) ? null : productFamily;  
                           oProduct.GSM_Type__c=  AppUtils.isKeysetNotFound(gsmType) ? null : gsmType;  
                           oProduct.SIM_Type__c=  AppUtils.isKeysetNotFound(simType) ? null : simType;
                           oProduct.Revenue_Type__c=  AppUtils.isKeysetNotFound(chargeType) ? null : chargeType;  
                           // todo: add standardprice 
                           oProduct.IsActive=  true;  
                           uniqueNumber= apputils.getUniqueNumber();
                           oProduct.unique_no__c = uniqueNumber;
                           listProduct.add (oProduct); 
                        }
                   //} end od for
                   
                        if (status != 'failed'){
                            insert listProduct;
                            PRODUCT2 p = [select id from product2 where unique_no__c  =:uniqueNumber order by createddate desc limit 1];
                            productSFID = p.id;
                            errCode = '0';
                        }
                   }   // .close from the status is not FAILED

                }   
                system.debug('============ requestid : ' + requestid );
                 
                /* -----end of process---- */
                
            }
            catch (Exception e) {
                status ='failed';
                errCode = '1';
                calllog.status__c = 'Failed';
                errMessage = 'Error on POST Product method.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessage);
                AppUtils.putError(errMessage );
                
            }
            
            // put response data 
            RESTResult restResult = new RESTResult(); 
            restResult.header.service = service;
            restResult.header.request_id = requestid;
            restResult.header.response_id = AppUtils.getUniqueNumber();
            restResult.header.status = status;
            restResult.body.data.product_sfid = productSFID; 
            restResult.body.except.error_message = errMessage;
            restResult.body.except.error_code = errCode;
            
            // put callout information then save the data on Call_Log object
            calllog.response_end_time__c = datetime.now();     
            calllog.response_message__c = JSON.serialize(restResult) ;            
            insert calllog;
            
            return restResult ;
    }


    /*
     * THIS METHOD FOR PRODUCTS UPDATE PROCESS
     *
     */
    @HttpPut
    global static RESTResult doPut(){

        String param ='';
        String status ='';
        String service ='';
        String requestid ='';
        String errMessage ='-';
        String errCode ='-';
        
        String ipAddressRequestCameFrom='';
        String currentRequestURL;
        String sfdcBaseURL;
        
        string productSFID;
        string productCode ;
        string productName ;
        string sapCode  ;
        string productDescription  ;
        string productFamily  ;
        string gsmType  ;
        string simType  ;
        string chargeType  ;
        string standardPrice  ;
        
        Call_Log__c calllog = new Call_Log__c();
        calllog.type__c='Callin';
        calllog.method__c = 'PUT';
        calllog.request_start_time__c = datetime.now();

        try  {
                RestRequest request = RestContext.request;
                //RestResponse response = RestContext.response;
                param = RestContext.request.requestBody.toString().trim();
                status ='success';
                
                // put callout information
                calllog.request_message__c = param ;
                calllog.response_message__c = status;
                calllog.status__c = status ;
                calllog.uri__c = request.requestURI;
                
                ipAddressRequestCameFrom = request.remoteAddress;
                system.debug ('============= ipAddressRequestCameFrom : ' + ipAddressRequestCameFrom );
                system.debug ('============= ipAddressRequestCameFrom : ' + ipAddressRequestCameFrom );
                system.debug ('============= request.headers          : ' + request.headers);
                system.debug ('============= request.httpMethod       : ' + request.httpMethod);
                system.debug ('============= request.params           : ' + request.params);
                system.debug ('============= request.remoteAddress    : ' + request.remoteAddress);
                system.debug ('============= request.requestBody      : ' + request.requestBody);
                system.debug ('============= request.requestURI       : ' + request.requestURI);
                system.debug ('============= request.resourcePath     : ' + request.resourcePath);

                // Get the base URL.
                sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                System.debug('Base URL: ' + sfdcBaseURL );       
                
                // Get the URL for the current request.
                currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
                System.debug('Current request URL: ' + currentRequestURL); 
                
                calllog.callerFrom__c = ipAddressRequestCameFrom ;                   
                calllog.endpoint__c = currentRequestURL.replace (calllog.uri__c,'');                
                
                
                /* -- MAIN PROCESS -- */

                Map<String, Object> paramMap = (Map<String, Object>) JSON.deserializeUntyped(param);
                system.debug('============ paramMap  : ' + paramMap );
                
                if(paramMap.size() > 0){   
                   requestid = AppUtils.getStringDataOnMap(paramMap , 'header::request_id');
                   service = AppUtils.getStringDataOnMap(paramMap , 'header::service');

                   if (service != 'updateproduct') {
                       // the service is NOT RELEVANT

                       status = 'failed';
                       errMessage = 'the service is not relevant';
                       errCode = '1';
                   }
                   else {
                        // the service name is RELEVANT
                        
                        Map<string, Object> mapRec = (Map<string, Object>) appUtils.getObjectDataOnMap(paramMap,'body::data');

                        Product2 oProduct = new Product2 ();       
                        List <Product2> listProducts = new List <Product2>();                
                       
                        productCode = AppUtils.getStringDataOnMap(mapRec , 'product_code');
                        productSFID = AppUtils.getStringDataOnMap(mapRec , 'product_sfid');
                        productName = AppUtils.getStringDataOnMap(mapRec , 'product_name');
                        sapCode = AppUtils.getStringDataOnMap(mapRec , 'sap_code');
                        productDescription = AppUtils.getStringDataOnMap(mapRec , 'product_description');
                        productFamily = AppUtils.getStringDataOnMap(mapRec , 'product_family');
                        gsmType = AppUtils.getStringDataOnMap(mapRec , 'gsm_type');
                        simType = AppUtils.getStringDataOnMap(mapRec , 'sim_type');
                        chargeType = AppUtils.getStringDataOnMap(mapRec , 'charge_type');
                        standardPrice = AppUtils.getStringDataOnMap(mapRec , 'standard_price');
                                                

                        List <Product2> tmpProducts = new List <Product2>() ;
                        
                        // Get Product Record data
                        System.debug(' ============ SQL : SELECT id FROM Product2 WHERE id = ' + productSFID);
                        if (! (AppUtils.isKeysetNotFound(productSFID) || productSFID=='' ) ){
                                tmpProducts = [SELECT id FROM Product2 WHERE id = :productSFID  LIMIT 1 ];
                                system.debug('============ tmpProducts : ' + tmpProducts);
                                
                                if (tmpProducts.size() > 0){
                                    oProduct = tmpProducts[0];
                                    status = 'success';
                                }
                                else {
                                    status = 'failed';
                                    errMessage = 'Salesforce ID not found on the data. ';
                                    errCode = '1';
                                }
                        }

                        if (AppUtils.isKeysetNotFound(productSFID) || productSFID=='' ) {
                            status = 'failed';
                            errMessage = 'Salesforce ID not found on the data. ';
                            errCode = '1';
                        }            

                        if (status != 'failed') {
                            oProduct.ProductCode=  AppUtils.isKeysetNotFound(productCode) ? null : productCode;  
                            oProduct.Name=  AppUtils.isKeysetNotFound(productName) ? null : productName;  
                            oProduct.SAP_Code__c=  AppUtils.isKeysetNotFound(sapCode) ? null : sapCode;  
                            oProduct.description=  AppUtils.isKeysetNotFound(productDescription) ? null : productDescription;  
                            oProduct.Family=  AppUtils.isKeysetNotFound(productFamily) ? null : productFamily;  
                            oProduct.GSM_Type__c=  AppUtils.isKeysetNotFound(gsmType) ? null : gsmType;  
                            oProduct.SIM_Type__c=  AppUtils.isKeysetNotFound(simType) ? null : simType;
                            oProduct.Revenue_Type__c=  AppUtils.isKeysetNotFound(chargeType) ? null : chargeType;  
                            // todo: add standardprice 
                            

                            listProducts.add (oProduct); 
                            }     
                            System.debug('=================== oProduct : ' + oProduct);
                    
                            if (status != 'failed'){
                                update listProducts;
                                errCode = '0';
                            } 

                    }   // .close from the service name is relevant

                }
                system.debug('============ requestid : ' + requestid );
                 
                /* -----end of process---- */                                                            

            }
            catch (Exception e) {
                status ='failed';
                errCode = '1';
                
                calllog.status__c = 'Failed';
                errMessage = 'Error on PUT Product method.::' + e.getmessage() + '::' + e.getLineNumber() ;
                system.debug('==================== error message : ' + errMessage);
                AppUtils.putError(errMessage );
            }
            
            // put response data 
            RESTResult restResult = new RESTResult(); 
            restResult.header.service = service;
            restResult.header.request_id = requestid;
            restResult.header.response_id = AppUtils.getUniqueNumber();
            restResult.header.status = status;
            restResult.body.except.error_message = errMessage;
            restResult.body.except.error_code = errCode;
            
            // put callout information then save the data on Call_Log object
            calllog.response_end_time__c = datetime.now();     
            calllog.response_message__c = JSON.serialize(restResult) ;      
            insert calllog;
            
            return restResult ;

    }
    
}