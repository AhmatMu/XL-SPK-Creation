global class SOAPContractExpired {
    webservice static String ExpireContract(String ContractID,String ContractitemID,String expireddate)
	{
		
		String response;
		if(expireddate=='')
		{
		Contract__c CT=[select id,ticketstatus__c from contract__c where Contract_ID__c=:ContractID ORDER BY CREATEDDATE DESC LIMIT 1];
		CT.TicketStatus__c='Complete';
		response='Contract Has Been Completed';
		update CT;
		}
		else
		{
		Contract_Item__c LCI=[SELECT id,active__c,end_date__c from contract_item__c WHERE Contract_item_sap_id__c=:Contractitemid AND Contract__r.Contract_id__C=:ContractID];
		Date D=date.newinstance(Integer.valueof(expireddate.left(4)),Integer.valueof(expireddate.substring(4,6)),Integer.valueof(expireddate.right(2)));
		LCI.end_date__c=D;
		LCI.Active__c=false;
		update LCI;
		response='Contract has been nonactive';
		}
		 Call_Log__c CL=new Call_Log__c();
        CL.endpoint__c='SOAPContractExpired';
        CL.Request_Message__c=ContractID+Contractitemid;
          CL.response_message__c=Response;
        CL.response_end_time__c=system.now();
        CL.Type__c='Callout';
        insert CL;
		
		return 'Success';
	}
}