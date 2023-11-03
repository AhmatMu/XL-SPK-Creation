/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 09-03-2022
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0   09-03-2022   Doddy Prima   Initial Version
**/
global class Schedule_Pending_Recurring implements Schedulable{
    global void execute(SchedulableContext sc){
        
        list<Pending_Recurring__c> listPR=[SELECT id,AM_Sales__c,AM_Email__c, AM_Email_by_Formula__c,  Service_Type__c,Amount__c,Total_Revenue__c,Search_Link__r.Link_ID__c,Pending_From__c,Segment__c,Pending_Type__c,Company__c,remark__c,Aging__c FROM Pending_Recurring__c WHERE Status__c='Send To Sales' ORDER BY Segment__c,AGING__c DESC,AM_Sales__c ASC,Company__c ASC,Search_Link__r.Link_ID__c];
        list <String> SegmentList=new list<String>
        {'Demo_Role','Banking & Financial Service','Energy, Resources & Global Partner','FMCG, Retail & Translog','Government & Public Sector','Media, E-Comm & ISP','Medium Enterprise','Strategic Project'};
            set<String> setamsales=new set<String>();
        list<String>listamsales=new list<String>();
        
        
        // 	list<String> AddressList=new list<String>();
        String addressemail='';
        Integer totalpendingsegment=0;
        List<String> args = new String[]{'0','number','###,###,##0.00'};
            for(Integer i=0;i<SegmentList.size();i++)
        {
            totalpendingsegment=0;
            list<User> Ulist=[SELECT id,email,manager.email FROM User WHERE UserRole.Name=:segmentlist[i] OR Userrole.Name LIKE 'Head%'];
            list<String> emailreceiver=new String[] {};
                list<String> emailreceivercc=new String[] {
                    system.label.cc_pending_recurring,
                    system.label.cc_pending_recurring2,
                    system.label.cc_pending_recurring3,
                    system.label.cc_Pending_Recurring4,
                    system.label.cc_Pending_Recurring5,
                    system.label.cc_Pending_Recurring6,
                    system.label.cc_Pending_Recurring7,
					system.label.cc_Pending_Recurring8
                    };
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:system.label.Pending_Recurring_Org_Wide_Email_Address];
            
            message.setOrgWideEmailAddressId(owea.get(0).Id);
            /*    for(user U:Ulist)
{
emailreceiver.add(U.Email);
}*/
            
            
            message.optOutPolicy = 'FILTER';
            datetime Now3=system.now().adddays(-3);
            String tanggaljumat=Now3.format('dd MMM yyyy');
            message.subject = 'Pending Recurring '+SegmentList[i]+ ' '+tanggaljumat;
            String messageBody = '<html><style> table#customers{font-family: "Trebuchet MS", Arial_Unicode_MS, sans-serif;border-collapse:collapse;width: auto;border: 1px solid grey;padding: 5px;font-size: 12px;}td#customers101{border: 1px solid black;padding: 2px;font-size: 8px;}</style>';
            MessageBody=Messagebody+'<body>Dear Team '+segmentlist[i]+', <br><br>Berikut ini dokumen yang harus dilengkapi untuk proses penagihan layanan yang masih tertunda (pending recurring) : <br><br>';
            messagebody=messagebody+'<table border="1" cellpadding="5" id="customers"><tr style="background-color:#0000FF;color:#FFFFFF"><td id="customers">AM</td><td>Company</td><td>Service</td><td>Link ID</td><td>Pending Document</td><td>Remarks</td><td>Pending Since</td><td>Aging(Days)</td><td>Price IDR/Month</td><td>Pending Revenue</td></tr>';
            // message.toaddresses=emailreceiver;
            //messagebody=messagebody+'<table id="t01"><tr><th>Segment</th><th>AM Name</th><th>Service</th><th>Invoicing Company</th><th>Lid</th><th>Pending Doc</th><th>Pending Since</th><th>Price IDR/Month</th><th>Outstanding Revenue</th></tr>';
            Integer counttr=0;
            string bgcolor='';
            String pendingfrom='';
            Decimal totalpendingrevenue=0;
            listamsales=null;
            totalpendingrevenue=0;
            datetime datetimependingfrom=datetime.newinstance(2019,1,1,0,0,0);
            //untuk membagi pending recurring email per segment, kalau masih segment sama, rownya ditambah tapi kalau sudah beda segment maka emailnya dibedakan
            for(Pending_Recurring__c PR:listPR)
            {
                
                
                if(PR.Segment__c==segmentlist[i])
                {
                    counttr=counttr+1;
                    for(User U:Ulist)
                    {
                        system.debug('=== AM_Email_by_Formula__c : ' + PR.AM_Email_by_Formula__c );
                        if(U.Email==PR.AM_Email_by_Formula__c )
                        {
                             system.debug('=== setAMSales : ' +setAMSales);
                            if(!setAMSales.contains(PR.AM_Email_by_Formula__c ))
                               
                            {
                                setAMSales.add(PR.AM_Email_by_Formula__c );
                                emailreceiver.add(PR.AM_Email_by_Formula__c );
                            }
                            if(!setAMSales.contains(U.Manager.Email))
                            {
                                setAMSales.add(U.Manager.Email);
                                emailreceiver.add(U.Manager.Email);
                            }
                        }
                    }
                    if(math.mod(counttr,2)==1)
                        bgcolor='#ADD8E6';
                    else
                        bgcolor='#FFFFFF';
                    
                    String amountstring='0.00';
                    String totalrevenuestring='0.00';
                    datetimependingfrom=datetime.newinstance(PR.Pending_From__c.year(),PR.Pending_From__c.month(),PR.Pending_From__c.day(),0,0,0);
                    pendingfrom=datetimependingfrom.format('dd MMM yyyy');
                    if(PR.Amount__c!=null)
                        amountstring=String.format(PR.Amount__C.format(),args);
                    if(PR.Total_Revenue__c!=null)
                        totalrevenuestring=String.format(PR.Total_Revenue__C.format(),args);
                    messagebody=messagebody+'<tr style="background-color:'+bgcolor+';"><td>'+PR.AM_Sales__c+'</td><td>'+PR.Company__c+'</td><td>'+PR.Service_Type__c+'</td><td>'+PR.Search_Link__r.Link_ID__c+'</td><td>'+PR.Pending_Type__c+'</td><td>'+PR.Remark__c+'</td><td>'+pendingfrom+'</td><td>'+PR.Aging__c+'</td><td align="right">'+amountstring+'</td><td align="right">'+totalrevenuestring+'</Td></tr>';
                    //    messagebody=messagebody+'<tr><th>'+PR.Segment__c+'</th><th>'+PR.AM_Sales__c+'</th><th>'+PR.Service_Type__c+'</th><th>'+PR.Company__c+'</th><th>'+PR.Search_Link__r.Link_ID__c+'</th><th>'+PR.Pending_Type__c+'</th><th>'+PR.Pending_From__c+'</th><th>'+amountstring+'</th><th>'+totalrevenuestring+'</th></tr>';
                    totalpendingsegment=totalpendingsegment+1;
                    if(!test.isRunningTest())
                        totalpendingrevenue=totalpendingrevenue+PR.Total_Revenue__c;
                }
            }
            messagebody=messagebody+'<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td><B>Total:</B></td><td align="right"><B>'+String.format(TotalPendingRevenue.format(),args)+'</B></td>';
            messagebody=messagebody+'</table><br>Best Regards,<br>Operation Revenue Management</body>  </html>';
            message.setHtmlBody(messageBody); 
            message.toaddresses=emailreceiver;
            message.setCCAddresses(emailreceivercc);
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                if(totalpendingsegment>0) 
            {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            }
        }
    }
}