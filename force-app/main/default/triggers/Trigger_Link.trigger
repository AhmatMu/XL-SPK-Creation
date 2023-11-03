/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-17-2022
 * @last modified by  : ahmat.murad@saasten.com
 **/
trigger Trigger_Link on Link__c(before insert, before update, after insert, after update) {
	if (label.Is_Trigger_Link_On == 'YES') {
		list<Scheduled_Process__c > listSP = new list<Scheduled_Process__c > ();
		if (trigger.isinsert) {
			if (trigger.isbefore) {

				List<String> CIDs = new List<String> ();
				for (Link__c link: system.trigger.new) {
					CIDs.add(link.name);
				}
				system.debug('=== CIDs : ' + CIDs);

				List<Circuit__c > circuits = [select id, name from Circuit__c where name in: CIDs];
				Map<string, id> circuitsMap = new Map<String, ID> ();

				system.debug('=== circuits : ' + circuits);
				for (Circuit__c circuit: circuits) {
					circuitsMap.put(circuit.name, circuit.id);
				}
				system.debug('=== circuitsMap : ' + circuitsMap);

				for (Link__c link: system.trigger.new) {

					//-- get circuit id
					ID circuitID = circuitsMap.get(link.cid__c);
					system.debug('=== circuitID : ' + circuitID);

					if (circuitID<>null) {
						// put Circuit Related-field to LINK
						link.CID_RelD__c = circuitID;

					} else {
						//-- send email to admin
						/*
                     	Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
						message.toAddresses = new String[] {'doddy.kusumadhynata@saasten.com'};

						message.optOutPolicy = 'FILTER';
						message.subject = 'There is any Link Created but the CID record is not available' + ' '+ system.today();
						String messageBody = 
							'<html><body>Dear System Administrator ' +
							'<br><br>There is any Link Created but the CID record is not available on system<br><br>';

						messagebody=messagebody + 'Link ID 	: ' + link.link_id__c + '<br>';
						messagebody=messagebody + 'CID 		: ' + link.cid__c + '<br>';
						messagebody=messagebody + 'Url		: ' + 'https://cs72.salesforce.com/' + link.id + '<br>';

						message.setHtmlBody(messageBody); 
						Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
						Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
						*/

					}
				}
			}
		}

		if (trigger.isInsert) {
			if (trigger.isAfter) {
				List<Link__c > tmpLinks = new List<Link__c > ();
				for (Link__c link: system.trigger.new) {
					if (link.CID_RelD__c == null) {
						Link__c tmpLink = new Link__c();
						tmpLink.ID = link.ID;
						tmpLink.link_id__c = link.link_id__c;
						tmpLink.cid__c = link.cid__c;
						tmpLinks.add(tmpLink);

					}
                   
				}
				if (tmpLinks.size() > 0) {
					string systemAdminEmail2 = system.label.System_Admin_Email2;
					string[] systemAdminEmail2List = systemAdminEmail2.split(';');

					Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
					String[] emails = new List<String> ();

					for (String email: systemAdminEmail2List) {
						emails.add(email);
						system.debug('=== email : ' + email);
					}
					message.toAddresses = emails;

					message.optOutPolicy = 'FILTER';
					message.subject = 'There are any Links Created but then CID record is not available' + ' ' + system.today();
					String messageBody =
						'<html><body>Dear System Administrator ' +
						'<br><br>There are any Links Created but then CID record is not available on system<br><br>';

					messagebody = messagebody +
						'<table border="1"><tr><td>No.</td><td>Link ID</td><td>CID</td><td>Url</td></tr>';

					integer ind = 1;
					for (Link__c tmpLink: tmpLinks) {
						messagebody = messagebody +
							'<tr><td>' + ind + '.</td><td>' + tmpLink.link_id__c + '</td><td>' + tmpLink.cid__c + '</td>' +
							'<td>' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + tmpLink.id + '</td></tr>';

						ind++;
					}
					/*
					messagebody=messagebody + 'Link ID 	: ' + link.link_id__c +<br>';
					messagebody=messagebody + 'CID 		: ' + circuitID +<br>';
					messagebody=messagebody + 'Url		: ' + 'https://cs72.salesforce.com/' + link.id +<br>';
					*/
					messagebody = messagebody + '</table><br>Best Regards<br></body> </html>';

					message.setHtmlBody(messageBody);
					Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage > {
						message
					};
					Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
				}
			}

		}

		if (trigger.isupdate) {
			//update 28/11/2021 diky untuk mengkonfersi aging ke date
			if (trigger.isbefore) {
				for (Link__c link: system.trigger.new) {
					Link__c LInkoldObj = trigger.oldmap.get(link.id);

					if (LInkoldObj.Aging_Trial_Reminder_Date__c != link.Aging_Trial_Reminder_Date__c || LInkoldObj.Trial_End_Date__c != link.Trial_End_Date__c) {

						Integer agingDays;
						if (Link.Aging_Trial_Reminder_Date__c == null) {
							Link.Aging_Trial_Reminder_Date__c = '0';
							agingDays = 0;
						}

						if (Link.Aging_Trial_Reminder_Date__c != null) {
							agingDays = Integer.valueOf(Link.Aging_Trial_Reminder_Date__c) * -1;
						}

						//Integer aging = agingDays;
						if (agingDays != null) {
							if (link.Trial_End_Date__c != null) {
								link.Trial_Reminder_Date__c = link.Trial_End_Date__c.addDays(agingDays);
							}

						}

					}
				}
			}

			if (trigger.isafter) {

				for (Link__c link: system.trigger.new) {
					Link__c LInkold = trigger.oldmap.get(link.id);
					if (link.link_id__c != null && link.link_id__c != '') {

						datetime nextschedule = system.now().addminutes(2);
						String sYear = string.valueof(nextSchedule.year());
						String sMonth = string.valueof(nextSchedule.month());
						String sDay = string.valueof(nextSchedule.day());
						String sHour = string.valueof(nextSchedule.Hour());
						String sMinute = string.valueof(nextSchedule.minute());
						Scheduled_Process__c sp = new Scheduled_Process__c();
						sp.Execute_Plan__c = nextSchedule;
						sp.Type__c = 'Callout Link';
						sp.parameter1__c = link.link_id__c;

						Scheduled_Process_Services sps = new Scheduled_Process_Services();
						String sch = '0 ' + sMinute + ' ' + sHour + ' ' + sDay + ' ' + sMonth + ' ? ' + sYear;

						String jobID2 = 'Link ' + sch + '  Linkid No : ' + sp.parameter1__c; // system.schedule('Link ' + sch + '  Linkid No : ' + sp.parameter1__c, sch, sps);
						sp.parameter3__c = jobID2;
						sp.jobid__c = jobID2;
						sp.title__c = 'Update Link';
						listsp.add(sp);
						//insert sp; 

						//	  {REST_Callout_Update_Link.updatelink(link.link_id__c);}
						if(LInkold.Is_Trial__c == true && link.Is_Trial__c == false){
						
							
							REST_Callout_Update_Link.updatelink(link.link_id__c, '');
							system.debug('== call REST_Callout_Update_Link.updatelink ==');
							system.debug(' == trial old : ' + LInkold.Is_Trial__c + '== trial new : ' + link.Is_Trial__c );
	
						}
                         
					}

					
				}
			}
		}
		insert listSP;
	}

}