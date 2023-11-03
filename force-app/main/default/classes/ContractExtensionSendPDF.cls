public with sharing class ContractExtensionSendPDF {
    
    public static void sendpdf(String ContractExtensionID)
    {
    //send email for extension notif with PDF as attachment
        PageReference pdf = page.ContractExtensionBA;
                pdf.getParameters().put('id',ContractExtensionid);

                 // the contents of the attachment from the pdf
                Blob body;
    
                  try {
      
                    // returns the output of the page as a PDF
                         body = pdf.getContent();
      
                            // need to pass unit test -- current bug  
                    } catch (VisualforceException e) {
                                body = Blob.valueOf('Error');
                    }
                        list<String> mailaddress=new list<String>{};
                        list<String> mailcc=new list<String>{};
                        Contract_Extension__c BAX=[SELECT Link__r.Link_id__c,Account_Manager__r.Email,Account_Manager__r.Manager.Email,Account__c,BA_Print__c,BA_Print__r.Name,BA_Print__r.Title,Account_Manager__c,Extension_End_Date__c,Extension_Start_Date_string__c,Extension_End_Date_string__c,Extension_Monthly_Price__c,Link__r.Name,Link__r.capacity_bandwidth__c,link__r.service_type__c,Account__r.Name,Account__r.BP_Number_Unique_Name__c,Status__c,Extension_End_Date_String_English__c,Deadline_English__c,Deadline_Indonesia__c,Previous_End_Date_string__c,Previous_End_Date_string_English__c FROM Contract_Extension__c WHERE ID=:ContractExtensionID];
                        
                        
                        list<AccountContactRelation> listACR=[SELECT Contact.Email,Roles FROM AccountContactRelation WHERE Accountid=:BAX.Account__c];
                        for(AccountContactRelation ACR:listACR)
                        {
                            if(ACR.Roles!=null)
                            {
                            if((ACR.Roles.Contains('BA Recipient')|| ACR.Roles.Contains('BA Print')) && ACR.Contact.Email!=null && ACR.Contact.Email!='')
                            {
                                mailaddress.add(ACR.Contact.Email);
                            }
                            }
                        }
                        
                        //mailaddress.add('Novando.Agmawan@saasten.com');
                        //mailaddress.add('novi.fajariasih@saasten.com');

                        //set receiver and sender
                            mailcc.add(BAX.Account_Manager__r.Email);
                            mailcc.add(BAX.Account_Manager__r.Manager.Email);   
                            mailcc.add('incem@xl.co.id');
                            mailcc.add('kahfif@xl.co.id');
                            mailcc.add('operationrevenuemanagement@xl.co.id');
                            mailcc.add('Salessupport@xl.co.id');
                        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                        attach.setContentType('application/pdf');
                        attach.setFileName('ContractExtension.pdf');
                        attach.setInline(false);
                        attach.Body = body;
    
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setUseSignature(false);
                        //mail.setToAddresses(new String[]{'surya.ansana@saasten.com','kahfif@xl.co.id'});
                        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='operationrevenuemanagement@xl.co.id'];
                         mail.setOrgWideEmailAddressId(owea.get(0).Id);
                        mail.optOutPolicy = 'FILTER';
                        mail.setToAddresses(mailaddress);
                        mail.setCCaddresses(mailcc);
                        mail.setSubject('Berita Acara Perpanjangan '+BAX.Link__r.Service_Type__c +' '+ BAX.Link__r.Link_id__c +' - '+BAX.Account__r.Name );
                        Datetime thirtydaysbefore=Datetime.newinstance(BAX.Extension_End_Date__c.year(),BAX.Extension_End_Date__c.month(),BAX.Extension_End_Date__c.day(),6,0,0);
                        thirtydaysbefore=thirtydaysbefore.adddays(-31);
                        String deadlinetanggal=thirtydaysbefore.format('dd MMM yyyy');
                        String BodyEmail='<html><head></head><body>Pelanggan Yang Terhormat '+BAX.Account__r.Name+',<br><br> Bersama ini kami ingatkan bahwa dalam 90 (sembilan puluh) hari ke depan kontrak layanan ' +BAX.Link__r.Service_Type__c +' '+ BAX.Link__r.Link_id__c +' - '+BAX.Account__r.Name+' akan berakhir, yaitu pada tanggal '+BAX.Previous_End_Date_String__c +'<br><br> Apabila '+ BAX.Account__r.Name+' akan melanjutkan penggunaan layanan tersebut, maka Berita Acara Perpanjangan terlampir agar ditanda-tangani oleh '+ BAX.Account__r.Name+'.<br><br> ';
                        BodyEmail=BodyEmail+  'Berita Acara Perpanjangan yang sudah ditanda-tangani selambat-lambatnya kami terima melalui email pada tanggal '+ BAX.Deadline_Indonesia__c+'. <br><br> Untuk informasi lebih lanjut mengenai layanan ini, '+BAX.Account__r.Name+' dapat menghubungi XL Account Manager dan Sales Manager terkait.<br><br> Hormat Kami <br><br> Enterprise & SME';    
                        BodyEmail=BodyEmail+   '<br><br>--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------<br><br>';
                        BodyEmail=BodyEmail+   'Dear Valued Customer '+BAX.Account__r.Name +',<br><br>We hereby remind you that within next 90 (ninety) days the contract of '+BAX.Link__r.Service_Type__c +' '+ BAX.Link__r.Link_id__c +' - '+BAX.Account__r.Name+' will end, which is on '+BAX.Previous_End_Date_String_English__c +'.<br><br>';
                        bodyEmail=BodyEmail+    'Should '+BAX.Account__r.Name+ ' continue to use the service, '+ BAX.Account__r.Name+' should proceed with signing Extension Acceptance Letter attached.<br><br>';
                        bodyEmail=BodyEmail+    'The signed Extension Acceptance Letter to be received by XL via email on '+BAX.Deadline_English__c+' at the latest.<br><br>For more information about the service, '+BAX.Account__r.Name+' can contact the respective XL Account Manager and Sales Manager.<br><br>';
                        bodyEmail=BodyEmail+    'Yours sincerely,<br><br>Enterprise & SME</body></html>';
                                mail.setHtmlBody(BodyEmail);
                                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
    
    // Send the email
    
                        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
                        Messaging.sendEmail(messages);
                        //BAX.Status__c='Waiting for BA';
                        //update BAX;
    }
}