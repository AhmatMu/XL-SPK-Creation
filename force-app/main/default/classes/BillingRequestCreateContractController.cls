/**
 * @description       : 
 * @author            : Diky Nurosid
 * @group             : 
 * @last modified on  : 03-13-2023
 * @last modified by  : Diky Nurosid
**/
public class BillingRequestCreateContractController {

    public List<Billing_Request__c> billingRequestRecords{get;set;}
    private static String retUrl;
    public PageReference backURL {get; set;}

    public BillingRequestCreateContractController(ApexPages.StandardSetController controller){
        billingRequestRecords = controller.getSelected();
       
    }
    
    public PageReference createContract(){
        try{
            if(billingRequestRecords.size() >0){
                List<Billing_Request__c> newBillingRequestList = new List<Billing_Request__c>();
                for (Billing_Request__c billingRequestRec : billingRequestRecords) {
                    billingRequestRec.Status__c = 'In Queue';
                    newBillingRequestList.add(billingRequestRec);
                }
                update newBillingRequestList;       
            }
        }catch (Exception e) {
            String errorMsg = e.getMessage(); 
            ApexPages.addMessages(e);
            return null; 
        }     
        PageReference pageRef = ApexPages.currentPage();
        String returl = isClassicOrLightning(pageRef);      

        return new PageReference(retUrl);
    }

    /**
     * checks if the current apex page is accessed from classic or lightning
     * @param PageReference apex current page url
     * @return return url reference
     */
    private static String isClassicOrLightning(Pagereference page){
        String retUrl;
         
        // get the return url if it's in Lightning view
        retUrl = apexpages.currentpage().getParameters().get('vfRetURLInSFX');      
        // get the return url if it's in classic view
        if(String.isBlank(retUrl)){
            retUrl = apexpages.currentpage().getParameters().get('retURL');
        }
        return retUrl;

     }

}