global class Schedule_Neglected_Opportunity implements Schedulable {
     global void execute(SchedulableContext sc){
     	List<EmailTemplate> lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'Neglected_Opportunity'];
     	list<Opportunity> A=[SELECT id,Owner_Email__c FROM Opportunity WHERE Service_Group__c='Non-GSM' AND 	StageName IN ('Prospecting','Survey','Negotiation') AND (Lastmodifieddate=:system.today().adddays(-14) OR Lastmodifieddate=:system.today().adddays(-21) OR Lastmodifieddate=:system.today().adddays(-28))];
 		for(Opportunity Opp:A)
 		{
 			sendEmail(Opp,lstEmailTemplates[0]);
 			
 		}
 		list<Opportunity> B=[SELECT id,Owner_Email__c FROM Opportunity WHERE Service_Group__c='Non-GSM' AND 	(StageName IN ('Quotation Final','Implementation') ) AND (Lastmodifieddate=:system.today().adddays(-14) OR Lastmodifieddate=:system.today().adddays(-21) OR Lastmodifieddate=:system.today().adddays(-7))];
 		for(Opportunity Opp:B)
 		{
 				sendEmail(Opp,lstEmailTemplates[0]);
 			
 		}
 		list<Opportunity> C=[SELECT id,Owner_Email__c FROM Opportunity WHERE Service_Group__c='Non-GSM' AND BA_Status__c=false AND StageName='Waiting for BA' AND (Waiting_for_BA_date__c=:system.today().adddays(-14) OR Waiting_for_BA_date__c=:system.today().adddays(-21) OR Waiting_for_BA_date__c=:system.today().adddays(-7))];
 		for(Opportunity Opp:C)
 		{
 			
 			sendEmail(Opp,lstEmailTemplates[0]);
 		}   
 		
 		
     }
     global void sendEmail(Opportunity Opp,EmailTemplate E)
 		{
 			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 			 mail.setTemplateId(E.Id);
 			 mail.setWhatId(Opp.id);
 			 list<String> Addresses=new list<String> {opp.owner_email__c};
 			mail.setToAddresses(Addresses);
 			mail.setSubject('Neglected Opportunity');
 			 if(!test.isrunningtest())
 			 Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
 		} 	
}