/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 10-26-2023
 * @last modified by  : Doddy Prima
**/
public class OrgUtils {
	Public String clientId;
    Public String clientSecret;
    Public String userName; 
    Public String password;
   	Public String accessToken;
    Public String orgType;
    Public String domainUrl;
    
    public OrgUtils (String clientId, String clientSecret, String userName, String password, String orgType) {
        this.clientId = clientId;
        this.clientSecret = clientSecret;
        this.userName = userName;
        this.password = password;
        this.orgType = orgType;
     
        
    }
        
    public string getAccessToken () {
        String accessToken = '';
        String endPoint = '';
        String uri = '';
        
        if (this.orgType == 'Sandbox') {
            endPoint = 'https://test.salesforce.com/services/oauth2/token?';
        }
        if (this.orgType == 'Production') {
            endPoint = 'https://login.salesforce.com/services/oauth2/token?';
        }
      
        uri = 'grant_type=password' + 
            	'&client_id=' + this.clientId + 
            	'&client_secret=' + this.clientSecret + 
            	'&username=' + this.userName +
            	'&password=' + this.password;
        
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(endpoint + uri);
        req.setMethod('POST');
        req.setHeader('Accept', 'application/json');

        Http http = new Http();
        HTTPResponse response = new HTTPResponse() ;

        
        if (!Test.isRunningTest()) {
            http = new Http();
            response = http.send(req);
            
            try {
                System.debug ('================= response message : ' + response.getBody ());
                Map<String,Object> responsemap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody ());
                
                accessToken = (string) responsemap.get('access_token');
                this.domainUrl = (string) responsemap.get('instance_url');
                
                System.debug ('================= access_token : ' + accessToken );
                System.debug ('================= this.domainUrl : ' + this.domainUrl );
                System.debug ('================= response message : ' + response.getBody ());         
    
            } catch (Exception e) {
                System.debug ('================= Error Message : ' + e.getmessage() + ' :: ' + e.getStacktraceString() );
            }            
        }
        
        this.accessToken = accessToken;
        return accessToken;
    } 
    
    
    
    public void getClassesAreNotReferenced () {
        Http httpProtocol = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint( domainUrl +			//Url.getOrgDomainURL().toExternalForm()+
                '/services/data/v47.0/tooling/query/?q='+
                'SELECT+RefMetadataComponentName'+
                '+FROM+MetadataComponentDependency'+
                '+WHERE+RefMetadataComponentType=\'ApexClass\'');
        
        //setting method and header
        req.setMethod('GET');
        //req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        req.setHeader('Authorization', 'Bearer ' + this.accessToken);
        
        req.setTimeout(120000);
        HttpResponse resp = httpProtocol.send(req);
        ApexDependencyWrapper classesWithDependency  = 
            (ApexDependencyWrapper) System.JSON.deserialize( resp.getBody(), ApexDependencyWrapper.Class );
        
        //only want custom classes, not from managed packages
        List<ApexClass> allClasses = [SELECT Name FROM ApexClass WHERE NamespacePrefix = null];
        
        //get all class names that are referenced
        List<String> classesReferenced = new List<String>();
        for(ApexDependencyWrapper.DependencyRecords apexDepRec : classesWithDependency.records){
            //ignore test classes that rely on apex classes
            if(apexDepRec.MetadataComponentName != null && !apexDepRec.MetadataComponentName.containsIgnoreCase('test')){
                classesReferenced.add(apexDepRec.RefMetadataComponentName);
            
            	if (apexDepRec.RefMetadataComponentName == 'AppUtils') {
                    System.debug('RefMetadataComponentName : ' + apexDepRec.RefMetadataComponentName);
                }
            }
        }
        
        //find which classes are not referenced in org
        List<String> classesNotReferenced = new List<String>();
        //not including test classes
        for(ApexClass apexName : allClasses){
            if(!classesReferenced.contains(apexName.Name) && !apexName.Name.containsIgnoreCase('test')){
                classesNotReferenced.add(apexName.Name);
            
            	if (apexName.Name == 'AppUtils') {
                    System.debug('apexName.Name : ' + apexName.Name);
                }
            }
        }
        
        System.debug('Classes with no references ' + classesNotReferenced);
        
        integer no = 1; 
        List<Meta_Data_Check__c> metaDataCheckList = New List<Meta_Data_Check__c> ();
        for (String apexName : classesNotReferenced) {
            System.debug('No. ' + no + ' ' + apexName);
            no++;
            
            Meta_Data_Check__c metaDataCheckREC = New Meta_Data_Check__c();
            metaDataCheckREC.Name = apexName;
            metaDataCheckREC.type__c = 'Apex Class';
            metaDataCheckREC.Not_Referenced__c = TRUE;
            metaDataCheckREC.As_Of__c = System.Now();
            metaDataCheckREC.Org_Type__c = this.orgType;
            metaDataCheckREC.Domain_URL__c = domainUrl;
                
            metaDataCheckList.add (metaDataCheckREC);
            
        }
        
        insert metaDataCheckList;
        
    }
    
    
    
    
    
    
    
    /**
     * how to use (sample)
     */
    
    /*

    String clientId = '3MVG9d8..z.hDcPKR3hdtY0J.p2y8bnfvMt79ktGJQmU2VACiMk4SfP3PWDSc9fBv1gt3ChP0hGVykfAGfbul';
    String clientSecret = '7158944652727720843';
    String userName = 'integration@xl.co.id'; 
    String password = 'demo1234FyfNaOhBVfNK5OvzI2o1cnCe';
    String orgType = 'Production';
    OrgUtils newOrgUtilsObj = New OrgUtils (clientId, clientSecret, userName, password, orgType);
    newOrgUtilsObj.getAccessToken();
    System.debug('=== Access Token : ' + newOrgUtilsObj.accessToken); 

	*/
}