public with sharing class IDCOMCheck_Controller {
    ApexPages.StandardSetController setCon; 
    ApexPages.StandardController con;
    
    public string IDCOMNumber {get;set;}
	public string comcodeAvabilityInfo {get;set;}
	public string responseStatus {get;set;}
    
 	
 	public IDCOMCheck_Controller (ApexPages.StandardSetController controller) {
 		setCon = controller;
 	}
 	public IDCOMCheck_Controller (ApexPages.StandardController controller) {
 		con = controller;
 	} 	 	
 	
 	//
 	
 	public void check () {
		//REST_Community.checkComm('XLEMP0137', null);
		//System.debug('IDCOMNumber '+ IDCOMNumber); 
		
		//REST_Community.checkComm(IDCOMNumber, null);
		REST_Community_Callout objRESTCommunityCallout = new REST_Community_Callout();
		if (!test.isRunningTest())
			responseStatus = objRESTCommunityCallout.checkComm(IDCOMNumber, null);
        
        if (responseStatus=='available') {
            comcodeAvabilityInfo = 'COMCODE has been used, please choose another comcode.' ; //+ objRESTCommunity.responseMessage;
        }
        else if (responseStatus=='not available') {
			comcodeAvabilityInfo = 'COMCODE is available to use.' ; //+ objRESTCommunity.responseMessage ;
			}
		else if (responseStatus=='failed') {
			comcodeAvabilityInfo = 'Checking Request is failed. ' ; //+ objRESTCommunity.responseMessage;
			}
				
 	}
 	
 	
}