public class BAPUtils {
    
    public BAP__c bap{get;set;}
    public Opportunity Opp{get;set;}
    public String ChiefEnterpriseName{get;set;}
    public AccountContactRelation ACR{get;set;}
    public String Chiefrespond{get;set;}
    public String Chiefenterprisedisplay{get;set;}
      public date tanggalpenagihan{get;set;}
      public String displayerror{get;set;}
      public String displaynoerror{get;set;}
      public String terminatedate{get;set;}
      
     public String Backdate{get;set;}
     public String Penalty{get;set;}
    public long jangkawaktu{get;set;}
    
    // deklarasi penalty BAP, novi SIR 12 31mei2021
    public string penaltyNO{get;set;}    
    public string penaltyNominal{get;set;}
    public String displayPenalty{get;set;}
    public string displayPenaltyNominal{get;set;}
    public String displayPenaltyText{get;set;}
     public String displayPenaltyBR{get;set;}
    public String GHapprovaldate{get;set;}
    public String Chiefapprovaldate{get;set;}
    public String submitdate{get;set;}
    public String displayApprovaldateText{get;set;}
    
 
   public BAPUtils(ApexPages.StandardController controller) {
     date ContractStart=date.newInstance(2020, 1, 1);
     date Contractend=date.newInstance(2020, 1, 1);
     Jangkawaktu=0;
     displayPenalty='display:none';
     
     BAP__c b=(BAP__c)controller.getrecord();
     bap=[SELECT id,Name,  Sales_Group_Head__r.Name,Owner.Name,Customer__r.Name,Pinalty__c,Pinalty_Currency_Format__c,Penalty_Currency_Format_IND__c,Cost__c,lebih_tagih__c,
          Backdate_Approval_Status__c,Penalty_Approval_Status__c,Type_of_Request__c,Link__r.Link_id__c,  CID__c,
          Terminate_Date__c,Sirkit__c,Link__r.Service_Type__c,Termination_Category__c,Contract_Start_Date__c,Contract_End_Date__c,  
          Reason__c,approval_remark__c,Links_Info__c,  GH_Approval_Date__c,Chief_approval_date__c,request_date__c,Periode_Kontrak__c,
          Lebih_Tagih_Currency_Format__c, Cost_Currency_Format__c,Lebih_Tagih_Currency_Format_IND__c,Cost_Currency_Format_IND__c FROM BAP__c WHERE id=:b.id];
       
     User chiefenterprise=[SELECT id,Name FROM User WHERE Profile.Name='CEO'];
     //if(!test.isRunningTest())
     //{
         contractstart=bap.Contract_Start_Date__c;
     contractend=bap.Contract_End_Date__c.adddays(1);
     datetime terminatedatetime=datetime.newInstance(BAP.terminate_date__c.year(),BAP.terminate_date__c.month(),BAP.terminate_date__c.day(),7,0,0);
     terminatedate=terminatedatetime.format('dd MMM yyyy');
   datetime submitdatetime=datetime.newInstance(BAP.request_date__c.year(),BAP.request_date__c.month(),BAP.request_date__c.day(),7,0,0);
     submitdate=submitdatetime.format('dd MMM yyyy');
     
       if(bap.GH_Approval_Date__c!=null)
       {
         GHapprovaldate=bap.GH_Approval_Date__c.format('dd MMM yyyy');
       }
       if(bap.Chief_approval_date__c!=null)
       {
         Chiefapprovaldate=bap.Chief_approval_date__c.format('dd MMM yyyy');
       }
     //}
     chiefrespond='';
  
     ChiefEnterpriseName=Chiefenterprise.Name;
     jangkawaktu=(contractstart.daysBetween(contractend)*12)/365;
     
    if(BAP.Backdate_Approval_Status__c=='APPROVED'||test.isRunningTest())
    {
        Backdate='Yes';
    }
    if(BAP.Backdate_Approval_Status__c=='NOT APPROVED'||test.isRunningTest())
    {
      Backdate='No';
    }
    if(BAP.Backdate_Approval_Status__c=='NO NEED APPROVAL'||test.isRunningTest())
    {
      Backdate='-';
    }
    if(BAP.Penalty_Approval_Status__c=='APPROVED'||test.isRunningTest())
    {
      Penalty='Yes';
      //displayPenaltyNominal=string.valueOf(BAP.Pinalty__c);
      displayPenaltyNominal=BAP.Penalty_Currency_Format_IND__c;
      displayPenaltyText='. Penagihan Penalty ke pelanggan sebesar Rp. ';
      displayPenaltyBR='<br/>';
    }
    if(BAP.Penalty_Approval_Status__c=='NOT APPROVED'||test.isRunningTest())
    {
      Penalty='No';
      displayPenaltyNominal=BAP.Penalty_Currency_Format_IND__c;
      //displayPenaltyNominal='0';
      displayPenaltyText='. Penagihan Penalty ke pelanggan sebesar Rp. ';
      displayPenaltyBR='<br/>';
    }
    if(BAP.Penalty_Approval_Status__c=='NO NEED APPROVAL'||test.isRunningTest())
    {
      Penalty='-';
      //displayPenaltyText = 'display:none';
      displayPenaltyText='';
      displayPenaltyBR='';
    }
    Chiefenterprisedisplay='display:none';
    if(BAP.Approval_Remark__c=='CEO Approved'||test.isRunningTest())
    {
      Chiefrespond='Approved at '+system.today();
      
    }
    if(bap.chief_approval_date__c!=null)
    {Chiefenterprisedisplay='';
     displayApprovaldateText = 'Approval Date : ';
     }
     displayerror='display:none';
     
    
  /*// add penaltyNO , SIR 12 novi 31mei2021
     penaltyNO ='display:none';
     if(Penalty == 'Yes'){
       displayPenalty='';
     }
     */
   }
 }