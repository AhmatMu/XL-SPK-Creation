public class CmpApprovalURLController  {
 public String objRecordID {get; set;}  

 public String urlStr{  
  get  {  
   return appUtils.generateApprovalURL(objRecordID);  
  }} 

}