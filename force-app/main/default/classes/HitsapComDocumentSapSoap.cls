/**
 * @description       : 
 * @author            : Doddy Prima
 * @group             : 
 * @last modified on  : 13-12-2021
 * @last modified by  : Doddy Prima
 * Modifications Log
 * Ver   Date         Author        Modification
 * 1.0                              Initial Version
 * 1.1   13-12-2021   Doddy Prima   set timeout to 2 minutes ( 120,000 milliseconds)
 *                                  ( Master.timeout_x = 120000; )
 * 
**/
public with sharing class HitsapComDocumentSapSoap {
  class ACR_Role_INFO {
      string role_value;
      string role_api_name;
      string role_sap_code;
      integer priority;
  }
  
 public static String[] AddressConvert(String longaddress,Integer address1max,Integer address2max,Integer address3max)
 {
   //convert address so it can be mapped to SAP format
   list<String> kembalian=new list<String>{'','',''};
  if(longaddress==null)
      return kembalian;
  list<string> potongan = longAddress.split(' ');
  string tmp='';
 
  string step='1st';
  
  For (string kata : potongan){
  if (step == '1st') {
      tmp = kembalian[0] + ' ' + kata; 
      tmp = tmp.trim();
      
      if (tmp.length() < address1max) {
          kembalian[0] = tmp;
      }
      else { step='2nd';}
  }

  if (step == '2nd') {
      tmp = kembalian[1] + ' ' + kata; 
      tmp = tmp.trim();
      if (tmp.length() < address2max) {
          kembalian[1] = tmp;
      }
      else { step='3rd';} 
  }

  if (step == '3rd') {
      tmp = kembalian[2] + ' ' + kata; 
      tmp = tmp.trim();
      if (tmp.length() < address3max) {
          kembalian[2] = tmp;
      }
      else { step='4th';} 
  }
  
  } 
      return kembalian;
 } 

 /*
 @future(callout=true) 
  public static void InsertContact(String ContactID,String AccountID,String Role) 
  {  
      list<Contact> C=[SELECT id,PIC_ID__c,Accountid,Name,firstname,lastname,email,mobilephone,phone,department FROM Contact WHERE ID=:Contactid];
      
      if(C.size()>0 && Role!=null)
      {
      Account A=[Select Name,BP_Number__c,Customer_type__c,No_NPWP__c from Account WHERE ID=:Accountid];
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036 AccountAddress=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036();
      AccountAddress.Task='P';
       AccountAddress.AddressType='G';
      AccountAddress.CustomerName1=A.Name;//'GEN name 1';
       AccountAddress.CustomerName2=A.Name;//'GEN name 2';
     AccountAddress.CustomerName3='';//'GEN name 3';
       AccountAddress.CustomerName4='';//'GEN name 4';
       AccountAddress.SearchTerm1='';//'GEN name';
       AccountAddress.Street1='';//'jl street gen1';
       AccountAddress.Street2='';//'jl street gen1';
       AccountAddress.Street3='';//'jl street gen1';
       AccountAddress.City='';//'Jakarta';
       AccountAddress.HouseNo='';//'88';
       AccountAddress.Region='';//'10';
       AccountAddress.PostalCode='';//'15144';
       AccountAddress.Country='';//'ID';
      list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036> listAccountAddress=new list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036>();
     // listAccountAddress.add(AccountAddress);
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00035 Account=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00035();
      Account.Task='P';
      Account.CustomerId='0000'+A.BP_Number__c;
      String TransactionDay=String.valueof(system.today().day());
      if(TransactionDay.length()==1)
       TransactionDay='0'+TransactionDay;
      String TransactionMonth=String.valueof(system.today().month());
       if(TransactionMonth.length()==1)
       TransactionMonth='0'+TransactionMonth;
      String TransactionDate=String.valueof(system.today().year())+transactionmonth+transactionday;
      Account.TransactionDate=TransactionDate;
      Transaction__c settings = Transaction__c.getOrgDefaults();
         Account.TransactionId=String.valueof(settings.transactionID__c);//'01234567';
        settings.transactionID__c= settings.transactionID__c+1;
     

        Account.VatNo=A.No_NPWP__c;//'6655778899';
       Account.CustomerClass='';//'01';
      Account.CustomerType=A.Customer_type__c;//'ENC';
       Account.Resv1='';
        if(!Role.Contains(';'))
       Role=Role+';';
       String[] RoleSplit=Role.split(';');
       list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037> listContact=new list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037>();
       for(String R:Rolesplit)
       {
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037 Contact=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037();
      Contact.Task='I';
      if(C[0].PIC_ID__c==null)
      C[0].PIC_ID__c='';
      Contact.ContactId=C[0].id;//C[0].PIC_ID__c;
      if(C[0].firstname==null)
      C[0].firstname='';
      if(C[0].department==null)
      C[0].department='';
      if(C[0].phone==null)
      C[0].phone='';
      if(C[0].mobilephone==null)
      C[0].mobilephone='';
      if(C[0].email==null)
      C[0].email='';
       Contact.Firstname=C[0].firstname;//'cp first name';
     Contact.Lastname=C[0].lastname;//'cp last name';
      Contact.Function='';
      if(R=='PIC UP Invoice')
      {
          Contact.Department='0018';
      }
       if(R=='PIC BA Recipient')
      {
          Contact.Department='0016';
      }
       if(R=='PIC BA Print')
      {
          Contact.Department='0017';
      }
     
      if(R=='PIC BA Sign')
      {
          Contact.Department='0019';
      }
      if(R=='PIC Print Invoice')
      {
          Contact.Department='0020';
      }
      if(R=='PIC Site'||R=='Contact Person') 
      {
          Contact.Department='0012';
      }
      Contact.Telephone=C[0].phone;//'021-55667788';
      Contact.Handphone=C[0].mobilephone;//'0818993322';
     Contact.Email=C[0].email;//'dediw@xl.co.id';
     if(Contact.Department!='')
            listContact.add(Contact); 
       }
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00037 PackageContact=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00037();
      PackageContact.item=listContact;
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00036 PackageAddress=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00036();
      PackageAddress.item=listAccountAddress;
      sapComDocumentSapSoapFunctionsMCS2.ZBD_SF_CUSTOMER_MASTER Master=new sapComDocumentSapSoapFunctionsMCS2.ZBD_SF_CUSTOMER_MASTER();
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00038 result=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00038();
     
      //  Master.clientCert_x='MIIFVzCCBD+gAwIBAgIQBaSeWyou+UIIoQL7ph10ZTANBgkqhkiG9w0BAQsFADBwMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMS8wLQYDVQQDEyZEaWdpQ2VydCBTSEEyIEhpZ2ggQXNzdXJhbmNlIFNlcnZlciBDQTAeFw0xNjA2MDYwMDAwMDBaFw0xODA2MTExMjAwMDBaMGsxCzAJBgNVBAYTAklEMRQwEgYDVQQIEwtES0kgSmFrYXJ0YTEQMA4GA1UEBxMHSmFrYXJ0YTESMBAGA1UEChMJWEwgQXhpYXRhMSAwHgYDVQQDExdlLXN1cHBsaWVybWdtdC54bC5jby5pZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPzaXIW+lLNcOyiVlVlPZg5ZUqFbOPbSq7Yv3smdsmUVM+Nt1NpBQKErbs0ZVQbhJOvCT+HCUsmJtC5dQBJFy6c00OaSuRS87ggsLGy9ZIztG53cHdysZBi8wXg1oXZFHHRJxp3u56lJWZa3jCV9pGdso7u07S3v2euRVJ+jMfNLS31PnnBYMcAXDXRNzw8h20K5g68RwXJG4InDweKd5pq2nV/PyvcLGTSDISV/otD4Ai0QL3S/iq4OVzKklnWE0V1ujWmrrcBeLmkUCtRbuKbGaESxJ0FJg3zhuZjUm5MBJWpsfBN5HKqaklrQGfEAQOHyDmJCEhHFqWIv4cO+XTMCAwEAAaOCAfAwggHsMB8GA1UdIwQYMBaAFFFo/5CvAgd1PMzZZWRiohK4WXI7MB0GA1UdDgQWBBSjBIKr3K1x8Z96UJVQHd0VoZ6eLjAiBgNVHREEGzAZghdlLXN1cHBsaWVybWdtdC54bC5jby5pZDAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMHUGA1UdHwRuMGwwNKAyoDCGLmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9zaGEyLWhhLXNlcnZlci1nNS5jcmwwNKAyoDCGLmh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWhhLXNlcnZlci1nNS5jcmwwTAYDVR0gBEUwQzA3BglghkgBhv1sAQEwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAIBgZngQwBAgIwgYMGCCsGAQUFBwEBBHcwdTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tME0GCCsGAQUFBzAChkFodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRTSEEySGlnaEFzc3VyYW5jZVNlcnZlckNBLmNydDAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBCwUAA4IBAQBQbp1pGM9T4EGEwGqqHMYFX+a2+TUTzcAj98zyVnyeUliSD1FHl/Zadtpkl9O8NL7ZIiVOvuk33UL1Y+DZtqQBqqOJWTCbB5ZXl6/C1Ag8EVQ6lQAGevMb6RUffCUVmBZ9J4tk4pg2yCTgvp9kiuH8PzyVavupQ/WRvAV2lodtxOydzj3+wPE8J+w6p8sbNnczMcRVzc0GB3j5Ix13tDFwlK73Bdcc4pDbjW3qB1FeGE760X6PybTrOrmuvGxkIVpm0S4WGZoy0elM0bMKqSkwjfCj8Hp8njIaJPqJULvGVdcHFCPJMDPIeWpQhgGy8hk89Jv2HviNTV/NRb3IJvTX';
      //  Master.clientCert_x='MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQD82lyFvpSzXDsolZVZT2YOWVKhWzj20qu2L97JnbJlFTPjbdTaQUChK27NGVUG4STrwk/hwlLJibQuXUASRcunNNDmkrkUvO4ILCxsvWSM7Rud3B3crGQYvMF4NaF2RRx0Scad7uepSVmWt4wlfaRnbKO7tO0t79nrkVSfozHzS0t9T55wWDHAFw10Tc8PIdtCuYOvEcFyRuCJw8Hineaatp1fz8r3Cxk0gyElf6LQ+AItEC90v4quDlcypJZ1hNFdbo1pq63AXi5pFArUW7imxmhEsSdBSYN84bmY1JuTASVqbHwTeRyqmpJa0BnxAEDh8g5iQhIRxaliL+HDvl0zAgMBAAECggEAWJtUzPGKPohVmtVAbvmp8+FNWYoUHjqZPdDsq459k3qookw8yPcQ5OnJfEoiR7TiMVP4lk54oHOHFrBK4Zxfz4psokBMZ34FlAuWzcxYziHCbK3LDulIB4VVkDFAiMZ445u8a1ktSglIvHTRNgQosWpYv/2FaD1pt1Y4FBaEr1ft9kEG3y9ywGD6woK6E7U3E8ZKSljWzw5TLtuRF1iKWsgJiqet9lwVTuyhzbc8MVuN2qJuizGuyzqmDerl1yH1ODTTsv3NwmHny94AmFYa6yDrh1CYACrB+IyPaZIBaBh6KSKgWLpSsIq3V5R7MsJgNUSpnpAz0mvYMbbrS9UEQKBgQD9p9hLd3Q4WH+S8SzJH51Ree4cxKrjIYFgJNscjxyXWTMFa2ea18A3Ddb34kLYC71y5AO1YLg8Ol74VfpFlJpuCaS3yL+LIpfEfowbmBPTdceHemlX6CM7kF97mas9A18zdFvi+2cxKBNZAyDd8MRsUiuVqzkWuU2pVvwwXhcJQKBgQD/MJ4Milkomn8Iw1A4RWszDHTuH/ILAfet0X5tSCOgBHtCsFAlNx9z961BmOtfkEElzccbp+uQFeBlsYu8vAE2HYbYXnHhDv4SWPYluxtqoQt5645ztfmLNMpYP4ZTQZpghj1so5Mjiej+8bZgG9yaq4nsopdN7x5ZySGnFQLodwKBgDzqoURGdM/PWRv19ZZ7lDFsAeZAyPVxJ3vqfgCW0fv6/QjRKXmDVPMjzLuNSBZQg3fjEIzvpG86aXJkW5ExoisngYQGOIYoNjbsv1QAPfrtq7rc3i7MD2epFGtk5J2motKVLzYFudPLWOAdJfAww9Us6VKNGEpjFecQwUrJe9lNAoGBAOY3Au5HRSXXMvFB2jXZklsMStSj5yS9Eqcxjj+iS9lJEbXY/4SDVRG2iAvcm8Krjco/+PbfJyjmQ3kakfijFuit/H9nvI6PivAcZ3skcBhizsqfkfSbX1ORPVYdgN3NGisoD3PZoZz3BkYw4xmTKRIz3IqpJ5x8MsJHK9/imawDAoGBAKl3xkefFrlawauDrymhkfFw23WuCxsyzCFgefIGfajkp9qLyAsFhmPYPEfeSzmGnDdOAeKXxUWrv3VWJaWoKulJcU9vnvyF4/xcSVvopb51ZgCvKfj6bW7sT2ntKXfbIm/Y8Jkj9/ls6XUWPXZf8j6JDfBrA02ec8HaCkkDiJ/p';           
//  String PK=EncodingUtil.base64Encode('舰Ўआ蘪虈෷܁ꀂංヵං˱ā1ରआ蘪虈෷܁ꀁංベւし҂ꀿȃȁဂꐅ实⸪䋹ꄈﬂᶦ整രआ蘪虈෷āԋ　ㅰ》؉唃؄ȓ单ᔱጰ̆ѕጊ䐌杩䍩牥⁴湉ㅣ〙ؗ唃଄ဓ睷⹷楤楧散瑲挮浯⼱ⴰ̆ѕጃ䐦杩䍩牥⁴䡓㉁䠠杩⁨獁畳慲据⁥敓癲牥䌠ぁ᜞ㄍ〶〶〶〰〰娰ഗ㠱㘰ㄱ㈱〰〰ずㅫ》؉唃؄ȓ䑉ᐱሰ̆ѕገ䐋䥋䨠歡牡慴ေะ̆ѕጇ䨇歡牡慴ሱူ̆ѕጊ堉⁌硁慩慴‱Ḱ̆ѕጃ攗猭灵汰敩浲浧⹴汸挮⹯摩舰∁രआ蘪虈෷āԁ̀Ƃ舰ਁ舂āﰀ峚뺅뎔㭜锨妕晏夎ꅒ㡛틶뚫?鷉斲㌕淣?䁁⮡쵮唙係싡쥒뒉崮ቀ쭅㒧릒바࣮Ⱜ뵬豤ᯭ??撬반磁ꄵ䕶琜왉ꧧ奉랖▌ꑽ汧뮣咑ꎟ䭋佽炞ㅘៀ琍콍ℏ䋛莹ᆯ狁쎉뚚徝쫏௷㐙Ↄ缥킢˸ိ琯調ຮ㉗隤葵巑赮ꭩ삭⹞ᑩ퐊롛욦䑨➱䥁粃맡풘鎛━汪፼ᱹ骪媒᧐ñ໲䉢ᄒ꧅⽢쏡嶾ȳăĀ芣舰ἰ̆ᵕУ〘耖儔ｨ꾐܂㱵?摥ꉢ렒牙〻؝唃ฝᘄᐄңꮂ규窟镐ᵐᗝ麡⺞∰̆ᵕБ〛舙攗猭灵汰敩浲浧⹴汸挮⹯摩ะ̆ᵕď！Єȃꀅᴰ̆ᵕХ〖ؔ⬈Ćԅ̇؁⬈Ćԅ̇。ٵ唃Ἕ渄氰㐰㊠゠⺆瑨灴⼺振汲⸳楤楧散瑲挮浯猯慨ⴲ慨猭牥敶⵲㕧挮汲㐰㊠゠⺆瑨灴⼺振汲⸴楤楧散瑲挮浯猯慨ⴲ慨猭牥敶⵲㕧挮汲䰰̆ᵕРぅぃط怉䢆蘁泽ā⨰⠰ࠆثԁ܅Ăᰖ瑨灴㩳⼯睷⹷楤楧散瑲挮浯䌯卐࠰؆腧ČȂ脰ڃ⬈ĆԅćЁぷふؤ⬈Ćԅ〇蘁栘瑴㩰⼯捯灳搮杩捩牥⹴潣ねٍ⬈Ćԅ〇蘂桁瑴㩰⼯慣散瑲⹳楤楧散瑲挮浯䐯杩䍩牥却䅈䠲杩䅨獳牵湡散敓癲牥䅃挮瑲ర̆ᵕē！Ȅ0രआ蘪虈෷āԋ̀Ƃ湐榝켘葁櫀Ც׆禮ጵ샍籖办鉘儏靇嫶?靤볓븴⋙严?뛙Ƥꎪ妉鬰阇靗슯ࣔᄼ㩔稆᯳ᗩ簟ᔥᚘ❽撋飢젶龾詤ﳡ㰿檕ꧻ벑瘅螖쑭鷬㷎샾㳱Ꜻᯋ眶ㄳ嗄췍܆兩ᴣ둷瀱꺔׷᳗郢跛儇ᡞ祈绑즏뤺벮摬娡텦ᘮ騙턲䳩돑ꤊ〩籺㊞␚觺뭐嗆ߗ⌔ド젳橹虐눁᧲䶍쵟뵅⛈ퟴ舰씃舰괂ΠĂȂȐ岬樦䀋辛礋껲╆ぷ؍⨉䢆čԁ氰଱र̆ѕጆ唂ㅓ〕ؓ唃਄ఓ楄楧敃瑲䤠据ᤱᜰ̆ѕጋ眐睷搮杩捩牥⹴潣ㅭ〫ة唃̄∓楄楧敃瑲䠠杩⁨獁畳慲据⁥噅删潯⁴䅃Ḱഗ㘰ㄱ〱〰〰〰᝚㌍ㄱㄱ〰〰〰娰氰଱र̆ѕጆ唂ㅓ〕ؓ唃਄ఓ楄楧敃瑲䤠据ᤱᜰ̆ѕጋ眐睷搮杩捩牥⹴潣ㅭ〫ة唃̄∓楄楧敃瑲䠠杩⁨獁畳慲据⁥噅删潯⁴䅃舰∁രआ蘪虈෷āԁ̀Ƃ舰ਁ舂ā였퓻ⴭ꘲㾁췉䤥熶쌪铕朴ઢ뀜楟䂦쒱늷킏꒘䆩㩙?횔?㡴䪤䷌舥䫷厥㠒浉酱捾ꮶ徦꓃扏빑엸?鈸ۣࣥ಑⣄啁쯻襚縕뼵牍㴉㪾倸睛ᬱ뎍Ⓡ驅겧m娔뜄Ꮊ凫頊䅁丢慥膇偁禦襜᧞坊⻕左匜縬춘ؚꐖ獨㓐ጄꅜ퍱籚?摞㟡ょіᇥ⦴ኀ秱蠹ʢ簑昧袷碷쫲ꠊꬸ搊뿂嵦蒕ꇁḥ嶇倚​찒뭁୮㡑䮸ˋăĀ掣愰ะ̆ᵕď！Єȃ蘁༰̆ᵕē！Ԅ̰āヿ؝唃ฝᘄᐄ㺱槃䞿퐁⚘ࠚ摣쌫ἰ̆ᵕУ〘耖넔쌾ͩ뿸Ň飔ᨦȈ揯⭤ッ؍⨉䢆čԁ舃āᰀؚ?鳗㲟暈ࠆ⅗⇛未뾪㈘䁶圐諁竳ᇙ蹥卑ﲞ땅?ㅌ롋ⱃ뎎칸祓홱⇥Ɣ嗚骇搤諶챦鳞촷㒨榱⎛黈≸瀫䝕愱았⾅ぎꃶᘱ젣ᙥ쬳ᪿꀛ廊ㆋ悋褈భ将띒龍頊ᗑ齟븒㙼㡣䒽群⛤ਫ韄൩賩샢圐좸ቶ喑䣲?⪼嬂䐏⃔?뫴♰遝鹠䮼ग됯ị桃߉섧峒뤡ቨ㲜뾜ﲞ岀掛ꩇ✥ꁧ舀命꧗ጮ瞣Ῠお҂ケ΂ꂙȃȁဂꓧ峜쁭䈫嶸鼕രआ蘪虈෷āԋ　ㅬ》؉唃؄ȓ单ᔱጰ̆ѕጊ䐌杩䍩牥⁴湉ㅣ〙ؗ唃଄ဓ睷⹷楤楧散瑲挮浯⬱⤰̆ѕጃ䐢杩䍩牥⁴楈桧䄠獳牵湡散䔠⁖潒瑯䌠ぁ᜞ㄍㄳ㈰ㄲ〲〰娰ഗ㠲〱㈲㈱〰〰ずㅰ》؉唃؄ȓ单ᔱጰ̆ѕጊ䐌杩䍩牥⁴湉ㅣ〙ؗ唃଄ဓ睷⹷楤楧散瑲挮浯⼱ⴰ̆ѕጃ䐦杩䍩牥⁴䡓㉁䠠杩⁨獁畳慲据⁥敓癲牥䌠ぁƂ〢؍⨉䢆čā舃༁　ƂȊƂ숯ؤ淈弄搊눆≽攦긖䁂캛鿜皟㸇ッ蝕뤙鑏娎ᾔ噕슴⨂킯䀋쓗㯐졲鸔郯ᆱ꺩죒䎸?ଋ헕꽀᷈䷭徜띗傆饨諵틚ׇꠟ즗ꓜ花ⶄ귆鲥ᧇꚂ྅䑞⩘輷㗽௱✈娲믵麋붤큑㯝㍂֣쐨⢻髌⮬ണ외煞䪷࠾臻ᚷꄖ⎝䴒ퟥ࢒疬鲤춺눗䐞攵卿㤥᳑騊᭣鈙桴㜊싂䡒㧋ꉚ셝ꃝ렠ꈡ⚓ᑯ⅊읁淭⽈ϳꋵ鉨⽓̂ꌁƂぉƂぅؒ唃ጝāӿ〈Ć！Ă　؎唃༝āӿ̄Ăゆ؝唃┝ᘄᐰࠆثԁ܅ăࠆثԁ܅ȃ㐰ࠆثԁ܅ā⠄☰␰ࠆثԁ܅İᢆ瑨灴⼺漯獣⹰楤楧散瑲挮浯䬰̆ᵕПいあꁀꀾ蘼栺瑴㩰⼯牣㑬搮杩捩牥⹴潣⽭楄楧敃瑲楈桧獁畳慲据䕥剖潯䍴⹁牣ぬؽ唃”㘄㐰㈰Іᵕ ⨰⠰ࠆثԁ܅Ăᰖ瑨灴㩳⼯睷⹷楤楧散瑲挮浯䌯卐ᴰ̆ᵕЎЖ儔ｨ꾐܂㱵?摥ꉢ렒牙〻؟唃⌝᠄ᘰᒀ㺱槃䞿퐁⚘ࠚ摣쌫രआ蘪虈෷āԋ̀Ƃ記覕?ﱜ栝䫪莏凖贯䑫鸖掬틵汮馄ꪋ熁宄㓭끎禷⦒ⷌ檀軰ꑹϾፇ쪆煙阄퍫塙︽㇓尥㠘ꎄ鿦ﶂ完㆘쵎鹸ﴚ쮅ꩉ⟲馋ﱲ꨾䇕?㛕뾡渜䥇广䣙ͼ﷙䦋颠䈦鋖ꐑ੤呗혝市걫쓮骀爒固힓뿿蔰〆ி乿埿鴅쎅שׂ疦겨ᘭ緯❹鷂܋ꫪ펅ꌁ⠠奁⡃臒ꫣ㭻뙷所ր䕁ؗ?㏀枛懓爮ﱩ䁗瀞ỵ듉1');
  //  Master.clientCert_x=PK; 
  //      Master.clientCertPasswd_x='S4Padmin';
  Master.inputHttpHeaders_x=new Map<String,String>();
          String username = 'xlsapint';
String password = 'jakarta03';
Blob headerValue = Blob.valueOf(username + ':' + password);
String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
Master.inputHttpHeaders_x.put('Authorization',authorizationHeader);
Master.inputHttpHeaders_x.put('Content-Type', 'text/xml');
      try{
      result=Master.ZsfCustomerMaster(PackageAddress,PackageContact,Account);
      list<sapComDocumentSapSoapFunctionsMCS2.Zexdsdst00097> msg=new list<sapComDocumentSapSoapFunctionsMCS2.Zexdsdst00097>();
      sapComDocumentSapSoapFunctionsMcS2.Zexdsdtt00052 rslt=new sapComDocumentSapSoapFunctionsMcS2.Zexdsdtt00052();
      list<sapComDocumentSapSoapFunctionsMcS2.Zcrmsdst00038> listitem=new list<sapComDocumentSapSoapFunctionsMcS2.Zcrmsdst00038>();
      listitem=result.Item;
      rslt=listitem[0].Messages;
      msg=rslt.item;
     
      Call_Log__c CL=new Call_Log__c();
      CL.endpoint__c=Master.endpoint_x;
 //    system.debug(msg[0]);
        CL.response_message__c=String.valueof(msg[0]);
        CL.Request_Message__c=String.valueof('  Contact'+PackageContact+'  AccountAddress'+PackageAddress+'   Account'+Account);
   // CL.Method__c='SAP';
      CL.response_end_time__c=system.now();
      CL.Type__c='Callout';
      insert CL;
       update settings;
      }
      catch(exception e)
      {
           Call_Log__c CL=new Call_Log__c();
      CL.endpoint__c=Master.endpoint_x;
 //    system.debug(msg[0]);
        CL.response_message__c=e.getmessage();
        CL.Request_Message__c=String.valueof('  Contact'+PackageContact+'  AccountAddress'+PackageAddress+'   Account'+Account);
   // CL.Method__c='SAP';
      CL.response_end_time__c=system.now();
      CL.Type__c='Callout';
      insert CL;
       update settings;
      }
      }
  }*/
  
  @future(callout=true) 
  public static void InsertContact2(String ContactID,String AccountID,String Role, string ACRMode) 
  {  
      Datetime startTime = system.now();
      String status = '';
      String errMessage = '';
      
      list<Contact> contactList=[SELECT id,PIC_ID__c,Accountid,Name,firstname,lastname,email,mobilephone,phone,department FROM Contact WHERE ID=:Contactid];
      //map variable
      if(contactList.size()>0 && Role!=null)
      {
          Contact contactObj = contactList[0];
          
          Account accountObj = [Select Name,BP_Number__c,Customer_type__c,No_NPWP__c from Account WHERE ID=:Accountid];
          sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00036 AccountAddress=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00036();
          AccountAddress.Task='P';
          AccountAddress.AddressType='G';
          AccountAddress.CustomerName1=accountObj.Name;//'GEN name 1';
          AccountAddress.CustomerName2=accountObj.Name;//'GEN name 2';
          AccountAddress.CustomerName3='';//'GEN name 3';
          AccountAddress.CustomerName4='';//'GEN name 4';
          AccountAddress.SearchTerm1='';//'GEN name';
          AccountAddress.Street1='';//'jl street gen1';
          AccountAddress.Street2='';//'jl street gen1';
          AccountAddress.Street3='';//'jl street gen1';
          AccountAddress.City='';//'Jakarta';
          AccountAddress.HouseNo='';//'88';
          AccountAddress.Region='';//'10';
          AccountAddress.PostalCode='';//'15144';
          AccountAddress.Country='';//'ID';
          list<sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00036> listAccountAddress=new list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00036>();
          // listAccountAddress.add(AccountAddress);
          sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00035 Account=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00035();
          Account.Task='P';
          Account.CustomerId='0000'+ accountObj.BP_Number__c;
          String TransactionDay=String.valueof(system.today().day());
          if(TransactionDay.length()==1)
              TransactionDay='0'+TransactionDay;
          
          String TransactionMonth=String.valueof(system.today().month());
          if(TransactionMonth.length()==1)
              TransactionMonth='0'+TransactionMonth;
          
          String TransactionDate=String.valueof(system.today().year())+transactionmonth+transactionday;
          Account.TransactionDate=TransactionDate;
          Transaction__c settings = Transaction__c.getOrgDefaults();
          Account.TransactionId=String.valueof(settings.transactionID__c);//'01234567';
          settings.transactionID__c= settings.transactionID__c+1;
          
          
          Account.VatNo= accountObj.No_NPWP__c;//'6655778899';
          Account.CustomerClass='';//'01';
          Account.CustomerType= accountObj.Customer_type__c;//'ENC';
          Account.Resv1='';
          if(!Role.Contains(';'))
              Role=Role+';';
          
          String[] RoleSplit=Role.split(';');
          list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037> listContact=new list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037>();
          
          //-- OLD WAY  
          /*
          for(String R:Rolesplit)
          {
              sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037 Contact=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037();
              Contact.Task='I';
              if(C[0].PIC_ID__c==null)
                  C[0].PIC_ID__c='';
              Contact.ContactId=C[0].id;//C[0].PIC_ID__c;
              if(C[0].firstname==null)
                  C[0].firstname='';
              if(C[0].department==null)
                  C[0].department='';
              if(C[0].phone==null)
                  C[0].phone='';
              if(C[0].mobilephone==null)
                  C[0].mobilephone='';
              if(C[0].email==null)
                  C[0].email='';
              Contact.Firstname=C[0].firstname;//'cp first name';
              Contact.Lastname=C[0].lastname;//'cp last name';
              Contact.Function='';
              if(R=='PIC UP Invoice')
              {
                  Contact.Department='0018';
              }
              if(R=='PIC BA Recipient')
              {
                  Contact.Department='0016';
              }
              if(R=='PIC BA Print')
              {
                  Contact.Department='0017';
              }
              
              if(R=='PIC BA Sign')
              {
                  Contact.Department='0019';
              }
              if(R=='PIC Print Invoice')
              {
                  Contact.Department='0020';
              }
              if(R=='PIC Site'||R=='Contact Person') 
              {
                  Contact.Department='0012';
              }
              Contact.Telephone=C[0].phone;//'021-55667788';
              Contact.Handphone=C[0].mobilephone;//'0818993322';
              Contact.Email=C[0].email;//'dediw@xl.co.id';
              if(Contact.Department!='')
                  listContact.add(Contact); 
          }
          */
          
          
          /** NEW WAY --------------------------------------------------------
            * send Contact to SAP for some ROLE only
            * August 28, 2020
            * by doddy
            * 
            * check to ROLE API name, sample : PIC Print Invoice#0020#1
            * 1. Role Name (PIC Print Invoice)
            * 2. Role / SAP Department Code (0020)
            * 3. Priority. 0 : avoid / no priority, 1 : first priority, 
            * If a contact have some ROLE that have priority 1 and 2 then just send for priority 1
            * If a contact have some ROLE that have priority 2 and 3 then just send for priority 2 
            * 
            **/
          
          integer rolePriorityChoosed = 0;
          boolean doCreateContact = false;
          sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037 Contact = null;
          
          //String ACRRolesInfo = system.label.ACR_ROLES_Info;
          //LIST<ACR_Role_INFO> ACRRolesInfoList = (LIST<ACR_Role_INFO>) JSON.deserializeUntyped (ACRRolesInfo);
          
          list<ACR_Roles_Configuration__c> ACRRolesConfigList =  [select Name, API_Name__c, SAP_Code__c, Priority__c from ACR_Roles_Configuration__c ];
          system.debug ('====== ACRRolesConfigList : ' + ACRRolesConfigList);

          Map<String, ACR_Roles_Configuration__c> ACRRIMap = new Map<String, ACR_Roles_Configuration__c>();
          for (ACR_Roles_Configuration__c ACRRolesConfig : ACRRolesConfigList) {
            ACRRIMap.put (ACRRolesConfig.API_Name__c, ACRRolesConfig);
          }
          /*
          for (ACR_Role_INFO ACRRI : ACRRolesInfoList) {
              ACRRIMap.put (ACRRI.role_api_name, ACRRI);
          }
          */
              
          for (String roleString :Rolesplit) {
              /*
              String[] roleStringItems=roleString.split('#');
              string roleLabel = roleStringItems[0].trim();
              string roleCode = roleStringItems[1];
              integer rolePriority = integer.valueof(roleStringItems[2]);
              */
              
              system.debug ('====== roleString : ' + roleString);

              ACR_Roles_Configuration__c ACRRItmp = ACRRIMap.get(roleString);
              string roleCode = '';
              integer rolePriority =0;
              if (ACRRItmp <> null) {
                roleCode = string.valueof ( ACRRItmp.SAP_Code__c );
                rolePriority= integer.valueof( ACRRItmp.Priority__c );
              }

              doCreateContact = false;
              
              //system.debug ('=== roleStringItems : ' +  roleStringItems);
              //system.debug ('=== roleLabel : ' +  roleLabel);
              
              system.debug ('=== ACRRItmp : ' +  ACRRItmp);
              system.debug ('=== roleCode : ' +  roleCode);
              system.debug ('=== rolePriority : ' +  rolePriority);
              system.debug ('=== rolePriorityChoosed  before : ' +  rolePriorityChoosed);
              
              //-- kirim contact yang role priority nya bukan 0 (1, 2, dst)
              if (rolePriority <> 0 ) {
                  if (rolePriorityChoosed == 0 ) {
                      rolePriorityChoosed = rolePriority ;
                      doCreateContact =true;
                  } else if (rolePriority < rolePriorityChoosed ) {
                      //-- jika priority lebih tinggi maka gunakan yang lebih tinggi
                      rolePriorityChoosed = rolePriority;
                      doCreateContact =true;
                  }
                  
                  If (doCreateContact ==true) {
                      Contact=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037();
                      
                      //--tutup dulu Contact.Task='I';
                      if (ACRMode == '' || ACRMode == null)
                          Contact.Task='I';
                      else Contact.Task=ACRMode;
                      
                      if(contactObj.PIC_ID__c==null)
                          contactObj.PIC_ID__c='';
                      
                      Contact.ContactId=contactObj.id;//C[0].PIC_ID__c;
                      
                      if(contactObj.firstname==null)
                          contactObj.firstname='';

                      if(contactObj.department==null)
                          contactObj.department='';

                      if(contactObj.phone==null)
                          contactObj.phone='';

                      if(contactObj.mobilephone==null)
                          contactObj.mobilephone='';

                      if(contactObj.email==null)
                          contactObj.email='';

                      Contact.Firstname=contactObj.firstname;//'cp first name';
                      Contact.Lastname=contactObj.lastname;//'cp last name';
                      Contact.Function='';
                      Contact.Department = roleCode;
                      Contact.Telephone=contactObj.phone;//'021-55667788';
                      Contact.Handphone=contactObj.mobilephone;//'0818993322';
                      Contact.Email=contactObj.email;//'dediw@xl.co.id';
                      
                  }
              }
              system.debug ('=== rolePriorityChoosed  after : ' +  rolePriorityChoosed);

          }
          system.debug ('=== Contact : ' +  Contact);

          if(Contact != null)
              listContact.add(Contact); 


          sapComDocumentSapSoapFunctionsMCShana.Zcrmsdtt00037 PackageContact=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00037();
          PackageContact.item=listContact;
          sapComDocumentSapSoapFunctionsMCShana.Zcrmsdtt00036 PackageAddress=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00036();
          PackageAddress.item=listAccountAddress;
          sapComDocumentSapSoapFunctionsMcSHANA.ZBD_SF_CUSTOMER_MASTER Master=new sapComDocumentSapSoapFunctionsMcSHANA.ZBD_SF_CUSTOMER_MASTER();
          sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00038 result=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00038();
          
          //Prepare to Hit to SAP
          Master.inputHttpHeaders_x = new Map<String,String>();
          Master.timeout_x = 120000; //-- set timeout to 2 minutes (December 13, 2021 by doddy)

          String username =system.label.SAPUsername;//'xlsapint';//'P2001211266';
          String password = apputils.doDecrypt(system.label.SAPPassword);//'jakarta03';//'M@nt4pXL';
          Blob headerValue = Blob.valueOf(username + ':' + password);
          String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
          Master.inputHttpHeaders_x.put('Authorization',authorizationHeader);
          Master.inputHttpHeaders_x.put('Content-Type', 'text/xml');
          try{
              result=Master.ZsfCustomerMaster(PackageAddress,PackageContact,Account);
              list<sapComDocumentSapSoapFunctionsMcSHANA.Zexdsdst00097> msg=new list<sapComDocumentSapSoapFunctionsMcSHANA.Zexdsdst00097>();
              sapComDocumentSapSoapFunctionsMcSHANA.Zexdsdtt00052 rslt=new sapComDocumentSapSoapFunctionsMcSHANA.Zexdsdtt00052();
              list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00038> listitem=new list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00038>();
              listitem=result.Item;
              rslt=listitem[0].Messages;
              msg=rslt.item;
              
              if(listitem[0].IsError=='')
                  status = 'Success';
              else if(listitem[0].IsError=='X')
                  status = 'Failed';  
              
              update settings;
          }
          catch(exception e)
          {
            status = 'Failed';
            errMessage =  ' :: error message : ' + e.getmessage() 
                  + ' :: StacktraceString : ' + e.getstacktraceString() 
                  + ' :: LineNumber : ' + e.getLineNumber() 
                  + ' :: Cause  : ' + e.getcause();
                  
            update settings;
          }
          
          //-- put call log
          Call_Log__c CL=new Call_Log__c();
          CL.Request_Start_Time__c = startTime;
          CL.CallerFrom__c  = 'Salesforce';
          CL.endpoint__c = Master.endpoint_x;
          CL.status__c = status;
          /*
          CL.Request_Message__c=String.valueof(' %% Contact : ' + JSON.serialize(PackageContact)
                                               + ' %%  AccountAddress : ' + JSON.serialize(PackageAddress)
                                               + ' %%  Account : '+ JSON.serialize(Account) );
          */
          
          CL.Request_Message__c=String.valueof('{ "Contact" :' + JSON.serialize(PackageContact) + ', '
                                               + ' "AccountAddress" : ' + JSON.serialize(PackageAddress)  + ', '
                                               + ' "Account" : '+ JSON.serialize(Account) + ' }'  );
              
          //CL.response_message__c=String.valueof(msg[0]);
          CL.response_message__c=String.valueof(JSON.serialize(result) );
          CL.error_message__c = errMessage;
          CL.response_end_time__c=system.now();
          CL.Type__c='Callout';
          insert CL;      
          
      }
  }

/*
   @future(callout=true) 
  public static void UpdateContact(String ContactID,String AccountID,String Role)
  { 
list<Contact> C=[SELECT id,PIC_ID__c,Accountid,Name,firstname,lastname,email,mobilephone,phone,department FROM Contact WHERE ID=:Contactid];
      
      if(C.size()>0)
      {
      Account A=[Select Name,BP_Number__c,no_npwp__c,customer_type__c from Account WHERE ID=:accountid];
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036 AccountAddress=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036();
      AccountAddress.Task='U';
       AccountAddress.AddressType='G';
      AccountAddress.CustomerName1=A.Name;//'GEN name 1';
       AccountAddress.CustomerName2=A.Name;//'GEN name 2';
     AccountAddress.CustomerName3='';//'GEN name 3';
       AccountAddress.CustomerName4='';//'GEN name 4';
       AccountAddress.SearchTerm1='';//'GEN name';
       AccountAddress.Street1='';//'jl street gen1';
       AccountAddress.Street2='';//'jl street gen1';
       AccountAddress.Street3='';//'jl street gen1';
       AccountAddress.City='';//'Jakarta';
       AccountAddress.HouseNo='';//'88';
       AccountAddress.Region='';//'10';
       AccountAddress.PostalCode='';//'15144';
       AccountAddress.Country='';//'ID';
      list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036> listAccountAddress=new list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036>();
    //  listAccountAddress.add(AccountAddress);
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00035 Account=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00035();
      Account.Task='P';
      Account.CustomerId='0000'+A.BP_Number__c;
      String TransactionDay=String.valueof(system.today().day());
      if(TransactionDay.length()==1)
       TransactionDay='0'+TransactionDay;
      String TransactionMonth=String.valueof(system.today().month());
       if(TransactionMonth.length()==1)
       TransactionMonth='0'+TransactionMonth;
      String TransactionDate=String.valueof(system.today().year())+transactionmonth+transactionday;
      Account.TransactionDate=TransactionDate;
      Transaction__c settings = Transaction__c.getOrgDefaults();
         Account.TransactionId=String.valueof(settings.transactionID__c);//'01234567';
        settings.transactionID__c= settings.transactionID__c+1;
     

        Account.VatNo=A.No_NPWP__c;//'6655778899';
       Account.CustomerClass='';//'01';
      Account.CustomerType=A.Customer_type__c;//'ENC';
       Account.Resv1='';
        if(!Role.Contains(';'))
       Role=Role+';';
     String[] RoleSplit=Role.split(';');
       list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037> listContact=new list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037>();
       for(String R:Rolesplit)
       {
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037 Contact=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037();
      Contact.Task='U';
      if(C[0].PIC_ID__c==null)
      C[0].PIC_ID__c='';
      Contact.ContactId=C[0].id;//C[0].PIC_ID__c;
      if(C[0].firstname==null)
      C[0].firstname='';
      if(C[0].department==null)
      C[0].department='';
      if(C[0].phone==null)
      C[0].phone='';
      if(C[0].mobilephone==null)
      C[0].mobilephone='';
      if(C[0].email==null)
      C[0].email='';
       Contact.Firstname=C[0].firstname;//'cp first name';
     Contact.Lastname=C[0].lastname;//'cp last name';
      Contact.Function='';
      if(R=='PIC UP Invoice')
      {
          Contact.Department='0018';
      }
       if(R=='PIC BA Recipient')
      {
          Contact.Department='0016';
      }
       if(R=='PIC BA Print')
      {
          Contact.Department='0017';
      }
      if(R=='PIC BA Sign')
      {
          Contact.Department='0019';
      }
      if(R=='PIC Print Invoice')
      {
          Contact.Department='0020';
      }
      if(R=='PIC Site'||R=='Contact Person') 
      {
          Contact.Department='0012';
      }
      Contact.Telephone=C[0].phone;//'021-55667788';
      Contact.Handphone=C[0].mobilephone;//'0818993322';
     Contact.Email=C[0].email;//'dediw@xl.co.id';
       if(Contact.Department!='')
            listContact.add(Contact);
       }
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00037 PackageContact=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00037();
      PackageContact.item=listContact;
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00036 PackageAddress=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00036();
      PackageAddress.item=listAccountAddress;
      sapComDocumentSapSoapFunctionsMCS2.ZBD_SF_CUSTOMER_MASTER Master=new sapComDocumentSapSoapFunctionsMCS2.ZBD_SF_CUSTOMER_MASTER();
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00038 result=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00038();
     
      //  Master.clientCert_x='MIIFVzCCBD+gAwIBAgIQBaSeWyou+UIIoQL7ph10ZTANBgkqhkiG9w0BAQsFADBwMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMS8wLQYDVQQDEyZEaWdpQ2VydCBTSEEyIEhpZ2ggQXNzdXJhbmNlIFNlcnZlciBDQTAeFw0xNjA2MDYwMDAwMDBaFw0xODA2MTExMjAwMDBaMGsxCzAJBgNVBAYTAklEMRQwEgYDVQQIEwtES0kgSmFrYXJ0YTEQMA4GA1UEBxMHSmFrYXJ0YTESMBAGA1UEChMJWEwgQXhpYXRhMSAwHgYDVQQDExdlLXN1cHBsaWVybWdtdC54bC5jby5pZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPzaXIW+lLNcOyiVlVlPZg5ZUqFbOPbSq7Yv3smdsmUVM+Nt1NpBQKErbs0ZVQbhJOvCT+HCUsmJtC5dQBJFy6c00OaSuRS87ggsLGy9ZIztG53cHdysZBi8wXg1oXZFHHRJxp3u56lJWZa3jCV9pGdso7u07S3v2euRVJ+jMfNLS31PnnBYMcAXDXRNzw8h20K5g68RwXJG4InDweKd5pq2nV/PyvcLGTSDISV/otD4Ai0QL3S/iq4OVzKklnWE0V1ujWmrrcBeLmkUCtRbuKbGaESxJ0FJg3zhuZjUm5MBJWpsfBN5HKqaklrQGfEAQOHyDmJCEhHFqWIv4cO+XTMCAwEAAaOCAfAwggHsMB8GA1UdIwQYMBaAFFFo/5CvAgd1PMzZZWRiohK4WXI7MB0GA1UdDgQWBBSjBIKr3K1x8Z96UJVQHd0VoZ6eLjAiBgNVHREEGzAZghdlLXN1cHBsaWVybWdtdC54bC5jby5pZDAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMHUGA1UdHwRuMGwwNKAyoDCGLmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9zaGEyLWhhLXNlcnZlci1nNS5jcmwwNKAyoDCGLmh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWhhLXNlcnZlci1nNS5jcmwwTAYDVR0gBEUwQzA3BglghkgBhv1sAQEwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAIBgZngQwBAgIwgYMGCCsGAQUFBwEBBHcwdTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tME0GCCsGAQUFBzAChkFodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRTSEEySGlnaEFzc3VyYW5jZVNlcnZlckNBLmNydDAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBCwUAA4IBAQBQbp1pGM9T4EGEwGqqHMYFX+a2+TUTzcAj98zyVnyeUliSD1FHl/Zadtpkl9O8NL7ZIiVOvuk33UL1Y+DZtqQBqqOJWTCbB5ZXl6/C1Ag8EVQ6lQAGevMb6RUffCUVmBZ9J4tk4pg2yCTgvp9kiuH8PzyVavupQ/WRvAV2lodtxOydzj3+wPE8J+w6p8sbNnczMcRVzc0GB3j5Ix13tDFwlK73Bdcc4pDbjW3qB1FeGE760X6PybTrOrmuvGxkIVpm0S4WGZoy0elM0bMKqSkwjfCj8Hp8njIaJPqJULvGVdcHFCPJMDPIeWpQhgGy8hk89Jv2HviNTV/NRb3IJvTX';
      //  Master.clientCert_x='MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQD82lyFvpSzXDsolZVZT2YOWVKhWzj20qu2L97JnbJlFTPjbdTaQUChK27NGVUG4STrwk/hwlLJibQuXUASRcunNNDmkrkUvO4ILCxsvWSM7Rud3B3crGQYvMF4NaF2RRx0Scad7uepSVmWt4wlfaRnbKO7tO0t79nrkVSfozHzS0t9T55wWDHAFw10Tc8PIdtCuYOvEcFyRuCJw8Hineaatp1fz8r3Cxk0gyElf6LQ+AItEC90v4quDlcypJZ1hNFdbo1pq63AXi5pFArUW7imxmhEsSdBSYN84bmY1JuTASVqbHwTeRyqmpJa0BnxAEDh8g5iQhIRxaliL+HDvl0zAgMBAAECggEAWJtUzPGKPohVmtVAbvmp8+FNWYoUHjqZPdDsq459k3qookw8yPcQ5OnJfEoiR7TiMVP4lk54oHOHFrBK4Zxfz4psokBMZ34FlAuWzcxYziHCbK3LDulIB4VVkDFAiMZ445u8a1ktSglIvHTRNgQosWpYv/2FaD1pt1Y4FBaEr1ft9kEG3y9ywGD6woK6E7U3E8ZKSljWzw5TLtuRF1iKWsgJiqet9lwVTuyhzbc8MVuN2qJuizGuyzqmDerl1yH1ODTTsv3NwmHny94AmFYa6yDrh1CYACrB+IyPaZIBaBh6KSKgWLpSsIq3V5R7MsJgNUSpnpAz0mvYMbbrS9UEQKBgQD9p9hLd3Q4WH+S8SzJH51Ree4cxKrjIYFgJNscjxyXWTMFa2ea18A3Ddb34kLYC71y5AO1YLg8Ol74VfpFlJpuCaS3yL+LIpfEfowbmBPTdceHemlX6CM7kF97mas9A18zdFvi+2cxKBNZAyDd8MRsUiuVqzkWuU2pVvwwXhcJQKBgQD/MJ4Milkomn8Iw1A4RWszDHTuH/ILAfet0X5tSCOgBHtCsFAlNx9z961BmOtfkEElzccbp+uQFeBlsYu8vAE2HYbYXnHhDv4SWPYluxtqoQt5645ztfmLNMpYP4ZTQZpghj1so5Mjiej+8bZgG9yaq4nsopdN7x5ZySGnFQLodwKBgDzqoURGdM/PWRv19ZZ7lDFsAeZAyPVxJ3vqfgCW0fv6/QjRKXmDVPMjzLuNSBZQg3fjEIzvpG86aXJkW5ExoisngYQGOIYoNjbsv1QAPfrtq7rc3i7MD2epFGtk5J2motKVLzYFudPLWOAdJfAww9Us6VKNGEpjFecQwUrJe9lNAoGBAOY3Au5HRSXXMvFB2jXZklsMStSj5yS9Eqcxjj+iS9lJEbXY/4SDVRG2iAvcm8Krjco/+PbfJyjmQ3kakfijFuit/H9nvI6PivAcZ3skcBhizsqfkfSbX1ORPVYdgN3NGisoD3PZoZz3BkYw4xmTKRIz3IqpJ5x8MsJHK9/imawDAoGBAKl3xkefFrlawauDrymhkfFw23WuCxsyzCFgefIGfajkp9qLyAsFhmPYPEfeSzmGnDdOAeKXxUWrv3VWJaWoKulJcU9vnvyF4/xcSVvopb51ZgCvKfj6bW7sT2ntKXfbIm/Y8Jkj9/ls6XUWPXZf8j6JDfBrA02ec8HaCkkDiJ/p';           
//  String PK=EncodingUtil.base64Encode('舰Ўआ蘪虈෷܁ꀂංヵං˱ā1ରआ蘪虈෷܁ꀁංベւし҂ꀿȃȁဂꐅ实⸪䋹ꄈﬂᶦ整രआ蘪虈෷āԋ　ㅰ》؉唃؄ȓ单ᔱጰ̆ѕጊ䐌杩䍩牥⁴湉ㅣ〙ؗ唃଄ဓ睷⹷楤楧散瑲挮浯⼱ⴰ̆ѕጃ䐦杩䍩牥⁴䡓㉁䠠杩⁨獁畳慲据⁥敓癲牥䌠ぁ᜞ㄍ〶〶〶〰〰娰ഗ㠱㘰ㄱ㈱〰〰ずㅫ》؉唃؄ȓ䑉ᐱሰ̆ѕገ䐋䥋䨠歡牡慴ေะ̆ѕጇ䨇歡牡慴ሱူ̆ѕጊ堉⁌硁慩慴‱Ḱ̆ѕጃ攗猭灵汰敩浲浧⹴汸挮⹯摩舰∁രआ蘪虈෷āԁ̀Ƃ舰ਁ舂āﰀ峚뺅뎔㭜锨妕晏夎ꅒ㡛틶뚫?鷉斲㌕淣?䁁⮡쵮唙係싡쥒뒉崮ቀ쭅㒧릒바࣮Ⱜ뵬豤ᯭ??撬반磁ꄵ䕶琜왉ꧧ奉랖▌ꑽ汧뮣咑ꎟ䭋佽炞ㅘៀ琍콍ℏ䋛莹ᆯ狁쎉뚚徝쫏௷㐙Ↄ缥킢˸ိ琯調ຮ㉗隤葵巑赮ꭩ삭⹞ᑩ퐊롛욦䑨➱䥁粃맡풘鎛━汪፼ᱹ骪媒᧐ñ໲䉢ᄒ꧅⽢쏡嶾ȳăĀ芣舰ἰ̆ᵕУ〘耖儔ｨ꾐܂㱵?摥ꉢ렒牙〻؝唃ฝᘄᐄңꮂ규窟镐ᵐᗝ麡⺞∰̆ᵕБ〛舙攗猭灵汰敩浲浧⹴汸挮⹯摩ะ̆ᵕď！Єȃꀅᴰ̆ᵕХ〖ؔ⬈Ćԅ̇؁⬈Ćԅ̇。ٵ唃Ἕ渄氰㐰㊠゠⺆瑨灴⼺振汲⸳楤楧散瑲挮浯猯慨ⴲ慨猭牥敶⵲㕧挮汲㐰㊠゠⺆瑨灴⼺振汲⸴楤楧散瑲挮浯猯慨ⴲ慨猭牥敶⵲㕧挮汲䰰̆ᵕРぅぃط怉䢆蘁泽ā⨰⠰ࠆثԁ܅Ăᰖ瑨灴㩳⼯睷⹷楤楧散瑲挮浯䌯卐࠰؆腧ČȂ脰ڃ⬈ĆԅćЁぷふؤ⬈Ćԅ〇蘁栘瑴㩰⼯捯灳搮杩捩牥⹴潣ねٍ⬈Ćԅ〇蘂桁瑴㩰⼯慣散瑲⹳楤楧散瑲挮浯䐯杩䍩牥却䅈䠲杩䅨獳牵湡散敓癲牥䅃挮瑲ర̆ᵕē！Ȅ0രआ蘪虈෷āԋ̀Ƃ湐榝켘葁櫀Ც׆禮ጵ샍籖办鉘儏靇嫶?靤볓븴⋙严?뛙Ƥꎪ妉鬰阇靗슯ࣔᄼ㩔稆᯳ᗩ簟ᔥᚘ❽撋飢젶龾詤ﳡ㰿檕ꧻ벑瘅螖쑭鷬㷎샾㳱Ꜻᯋ眶ㄳ嗄췍܆兩ᴣ둷瀱꺔׷᳗郢跛儇ᡞ祈绑즏뤺벮摬娡텦ᘮ騙턲䳩돑ꤊ〩籺㊞␚觺뭐嗆ߗ⌔ド젳橹虐눁᧲䶍쵟뵅⛈ퟴ舰씃舰괂ΠĂȂȐ岬樦䀋辛礋껲╆ぷ؍⨉䢆čԁ氰଱र̆ѕጆ唂ㅓ〕ؓ唃਄ఓ楄楧敃瑲䤠据ᤱᜰ̆ѕጋ眐睷搮杩捩牥⹴潣ㅭ〫ة唃̄∓楄楧敃瑲䠠杩⁨獁畳慲据⁥噅删潯⁴䅃Ḱഗ㘰ㄱ〱〰〰〰᝚㌍ㄱㄱ〰〰〰娰氰଱र̆ѕጆ唂ㅓ〕ؓ唃਄ఓ楄楧敃瑲䤠据ᤱᜰ̆ѕጋ眐睷搮杩捩牥⹴潣ㅭ〫ة唃̄∓楄楧敃瑲䠠杩⁨獁畳慲据⁥噅删潯⁴䅃舰∁രआ蘪虈෷āԁ̀Ƃ舰ਁ舂ā였퓻ⴭ꘲㾁췉䤥熶쌪铕朴ઢ뀜楟䂦쒱늷킏꒘䆩㩙?횔?㡴䪤䷌舥䫷厥㠒浉酱捾ꮶ徦꓃扏빑엸?鈸ۣࣥ಑⣄啁쯻襚縕뼵牍㴉㪾倸睛ᬱ뎍Ⓡ驅겧m娔뜄Ꮊ凫頊䅁丢慥膇偁禦襜᧞坊⻕左匜縬춘ؚꐖ獨㓐ጄꅜ퍱籚?摞㟡ょіᇥ⦴ኀ秱蠹ʢ簑昧袷碷쫲ꠊꬸ搊뿂嵦蒕ꇁḥ嶇倚​찒뭁୮㡑䮸ˋăĀ掣愰ะ̆ᵕď！Єȃ蘁༰̆ᵕē！Ԅ̰āヿ؝唃ฝᘄᐄ㺱槃䞿퐁⚘ࠚ摣쌫ἰ̆ᵕУ〘耖넔쌾ͩ뿸Ň飔ᨦȈ揯⭤ッ؍⨉䢆čԁ舃āᰀؚ?鳗㲟暈ࠆ⅗⇛未뾪㈘䁶圐諁竳ᇙ蹥卑ﲞ땅?ㅌ롋ⱃ뎎칸祓홱⇥Ɣ嗚骇搤諶챦鳞촷㒨榱⎛黈≸瀫䝕愱았⾅ぎꃶᘱ젣ᙥ쬳ᪿꀛ廊ㆋ悋褈భ将띒龍頊ᗑ齟븒㙼㡣䒽群⛤ਫ韄൩賩샢圐좸ቶ喑䣲?⪼嬂䐏⃔?뫴♰遝鹠䮼ग됯ị桃߉섧峒뤡ቨ㲜뾜ﲞ岀掛ꩇ✥ꁧ舀命꧗ጮ瞣Ῠお҂ケ΂ꂙȃȁဂꓧ峜쁭䈫嶸鼕രआ蘪虈෷āԋ　ㅬ》؉唃؄ȓ单ᔱጰ̆ѕጊ䐌杩䍩牥⁴湉ㅣ〙ؗ唃଄ဓ睷⹷楤楧散瑲挮浯⬱⤰̆ѕጃ䐢杩䍩牥⁴楈桧䄠獳牵湡散䔠⁖潒瑯䌠ぁ᜞ㄍㄳ㈰ㄲ〲〰娰ഗ㠲〱㈲㈱〰〰ずㅰ》؉唃؄ȓ单ᔱጰ̆ѕጊ䐌杩䍩牥⁴湉ㅣ〙ؗ唃଄ဓ睷⹷楤楧散瑲挮浯⼱ⴰ̆ѕጃ䐦杩䍩牥⁴䡓㉁䠠杩⁨獁畳慲据⁥敓癲牥䌠ぁƂ〢؍⨉䢆čā舃༁　ƂȊƂ숯ؤ淈弄搊눆≽攦긖䁂캛鿜皟㸇ッ蝕뤙鑏娎ᾔ噕슴⨂킯䀋쓗㯐졲鸔郯ᆱ꺩죒䎸?ଋ헕꽀᷈䷭徜띗傆饨諵틚ׇꠟ즗ꓜ花ⶄ귆鲥ᧇꚂ྅䑞⩘輷㗽௱✈娲믵麋붤큑㯝㍂֣쐨⢻髌⮬ണ외煞䪷࠾臻ᚷꄖ⎝䴒ퟥ࢒疬鲤춺눗䐞攵卿㤥᳑騊᭣鈙桴㜊싂䡒㧋ꉚ셝ꃝ렠ꈡ⚓ᑯ⅊읁淭⽈ϳꋵ鉨⽓̂ꌁƂぉƂぅؒ唃ጝāӿ〈Ć！Ă　؎唃༝āӿ̄Ăゆ؝唃┝ᘄᐰࠆثԁ܅ăࠆثԁ܅ȃ㐰ࠆثԁ܅ā⠄☰␰ࠆثԁ܅İᢆ瑨灴⼺漯獣⹰楤楧散瑲挮浯䬰̆ᵕПいあꁀꀾ蘼栺瑴㩰⼯牣㑬搮杩捩牥⹴潣⽭楄楧敃瑲楈桧獁畳慲据䕥剖潯䍴⹁牣ぬؽ唃”㘄㐰㈰Іᵕ ⨰⠰ࠆثԁ܅Ăᰖ瑨灴㩳⼯睷⹷楤楧散瑲挮浯䌯卐ᴰ̆ᵕЎЖ儔ｨ꾐܂㱵?摥ꉢ렒牙〻؟唃⌝᠄ᘰᒀ㺱槃䞿퐁⚘ࠚ摣쌫രआ蘪虈෷āԋ̀Ƃ記覕?ﱜ栝䫪莏凖贯䑫鸖掬틵汮馄ꪋ熁宄㓭끎禷⦒ⷌ檀軰ꑹϾፇ쪆煙阄퍫塙︽㇓尥㠘ꎄ鿦ﶂ完㆘쵎鹸ﴚ쮅ꩉ⟲馋ﱲ꨾䇕?㛕뾡渜䥇广䣙ͼ﷙䦋颠䈦鋖ꐑ੤呗혝市걫쓮骀爒固힓뿿蔰〆ி乿埿鴅쎅שׂ疦겨ᘭ緯❹鷂܋ꫪ펅ꌁ⠠奁⡃臒ꫣ㭻뙷所ր䕁ؗ?㏀枛懓爮ﱩ䁗瀞ỵ듉1');
  //  Master.clientCert_x=PK; 
  //      Master.clientCertPasswd_x='S4Padmin';
  Master.inputHttpHeaders_x=new Map<String,String>();
          String username = system.label.SAPUsername;//'xlsapint';
          String password = apputils.doDecrypt(system.label.SAPPassword);//'jakarta03';
Blob headerValue = Blob.valueOf(username + ':' + password);
String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
Master.inputHttpHeaders_x.put('Authorization',authorizationHeader);
Master.inputHttpHeaders_x.put('Content-Type', 'text/xml');
      try{
      result=Master.ZsfCustomerMaster(PackageAddress,PackageContact,Account);
      list<sapComDocumentSapSoapFunctionsMCS2.Zexdsdst00097> msg=new list<sapComDocumentSapSoapFunctionsMCS2.Zexdsdst00097>();
      sapComDocumentSapSoapFunctionsMcS2.Zexdsdtt00052 rslt=new sapComDocumentSapSoapFunctionsMcS2.Zexdsdtt00052();
      list<sapComDocumentSapSoapFunctionsMcS2.Zcrmsdst00038> listitem=new list<sapComDocumentSapSoapFunctionsMcS2.Zcrmsdst00038>();
      listitem=result.Item;
      rslt=listitem[0].Messages;
      msg=rslt.item;
     
      Call_Log__c CL=new Call_Log__c();
      CL.endpoint__c=Master.endpoint_x;
 //    system.debug(msg[0]);
        CL.response_message__c=String.valueof(msg[0]);
        CL.Request_Message__c=String.valueof('  Contact'+PackageContact+'  AccountAddress'+PackageAddress+'   Account'+Account);
   // CL.Method__c='SAP';
      CL.response_end_time__c=system.now();
      CL.Type__c='Callout';
      insert CL;
       update settings;
      }
          catch(exception e)
      {
           Call_Log__c CL=new Call_Log__c();
      CL.endpoint__c=Master.endpoint_x;
 //    system.debug(msg[0]);
        CL.response_message__c=e.getmessage();
        CL.Request_Message__c=String.valueof('  Contact'+PackageContact+'  AccountAddress'+PackageAddress+'   Account'+Account);
   // CL.Method__c='SAP';
      CL.response_end_time__c=system.now();
      CL.Type__c='Callout';
      insert CL;
       update settings;
      }
      }
}
*/
@future(callout=true) 
public static void UpdateContact2(String ContactID,String AccountID,String Role, string ACRMode)
{ 
    
  Datetime startTime = system.now();
  String status = '';
  String errMessage = '';
    
  //map variable to parameter
  list<Contact> contactList =[SELECT id,PIC_ID__c,Accountid,Name,firstname,lastname,email,mobilephone,phone,department FROM Contact WHERE ID=:Contactid];
    
    if(contactList.size()>0)
    {
        Contact contactObj = contactList[0];
            
        Account accountObj =[Select Name,BP_Number__c,no_npwp__c,customer_type__c from Account WHERE ID=:accountid];
        sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00036 AccountAddress=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00036();
        AccountAddress.Task='U';
        AccountAddress.AddressType='G';
        AccountAddress.CustomerName1=accountObj.Name;//'GEN name 1';
        AccountAddress.CustomerName2=accountObj.Name;//'GEN name 2';
        AccountAddress.CustomerName3='';//'GEN name 3';
        AccountAddress.CustomerName4='';//'GEN name 4';
        AccountAddress.SearchTerm1='';//'GEN name';
        AccountAddress.Street1='';//'jl street gen1';
        AccountAddress.Street2='';//'jl street gen1';
        AccountAddress.Street3='';//'jl street gen1';
        AccountAddress.City='';//'Jakarta';
        AccountAddress.HouseNo='';//'88';
        AccountAddress.Region='';//'10';
        AccountAddress.PostalCode='';//'15144';
        AccountAddress.Country='';//'ID';
        list<sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00036> listAccountAddress=new list<sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00036>();
        //  listAccountAddress.add(AccountAddress);
        sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00035 Account=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00035();
        Account.Task='P';
        Account.CustomerId='0000'+accountObj.BP_Number__c;
        String TransactionDay=String.valueof(system.today().day());
        if(TransactionDay.length()==1)
            TransactionDay='0'+TransactionDay;
        String TransactionMonth=String.valueof(system.today().month());
        if(TransactionMonth.length()==1)
            TransactionMonth='0'+TransactionMonth;
        String TransactionDate=String.valueof(system.today().year())+transactionmonth+transactionday;
        Account.TransactionDate=TransactionDate;
        Transaction__c settings = Transaction__c.getOrgDefaults();
        Account.TransactionId=String.valueof(settings.transactionID__c);//'01234567';
        settings.transactionID__c= settings.transactionID__c+1;
        
        
        Account.VatNo=accountObj.No_NPWP__c;//'6655778899';
        Account.CustomerClass='';//'01';
        Account.CustomerType=accountObj.Customer_type__c;//'ENC';
        Account.Resv1='';
        if(!Role.Contains(';'))
            Role=Role+';';
        String[] RoleSplit=Role.split(';');
        list<sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00037> listContact=new list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037>();
        
        
        //-- OLD WAY
        /*
        for(String R:Rolesplit)
        {
            sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00037 Contact=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00037();
            Contact.Task='U';
            if(C[0].PIC_ID__c==null)
                C[0].PIC_ID__c='';
            Contact.ContactId=C[0].id;//C[0].PIC_ID__c;
            if(C[0].firstname==null)
                C[0].firstname='';
            if(C[0].department==null)
                C[0].department='';
            if(C[0].phone==null)
                C[0].phone='';
            if(C[0].mobilephone==null)
                C[0].mobilephone='';
            if(C[0].email==null)
                C[0].email='';
            Contact.Firstname=C[0].firstname;//'cp first name';
            Contact.Lastname=C[0].lastname;//'cp last name';
            Contact.Function='';
           
            if(R=='PIC UP Invoice')
            {
                Contact.Department='0018';
            }
            if(R=='PIC BA Recipient')
            {
                Contact.Department='0016';
            }
            if(R=='PIC BA Print')
            {
                Contact.Department='0017';
            }
            if(R=='PIC BA Sign')
            {
                Contact.Department='0019';
            }
            if(R=='PIC Print Invoice')
            {
                Contact.Department='0020';
            }
            if(R=='PIC Site'||R=='Contact Person') 
            {
                Contact.Department='0012';
            }
            Contact.Telephone=C[0].phone;//'021-55667788';
            Contact.Handphone=C[0].mobilephone;//'0818993322';
            Contact.Email=C[0].email;//'dediw@xl.co.id';
            if(Contact.Department!='')
                listContact.add(Contact);
        }
        
        */
        
        /** NEW WAY --------------------------------------------------------
          * send Contact to SAP for some ROLE only
          * August 28, 2020
          * by doddy
          * 
          * check to ROLE API name, sample : PIC Print Invoice#0020#1
          * 1. Role Name (PIC Print Invoice)
          * 2. Role / SAP Department Code (0020)
          * 3. Priority. 0 : avoid / no priority, 1 : first priority, 
          * If a contact have some ROLE that have priority 1 and 2 then just send for priority 1
          * If a contact have some ROLE that have priority 2 and 3 then just send for priority 2 
          * 
          **/
          
          integer rolePriorityChoosed = 0;
          boolean doCreateContact = false;
          sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037 Contact = new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037();

          list<ACR_Roles_Configuration__c> ACRRolesConfigList =  [select Name, API_Name__c, SAP_Code__c, Priority__c from ACR_Roles_Configuration__c ];
          system.debug ('====== ACRRolesConfigList : ' + ACRRolesConfigList);

          Map<String, ACR_Roles_Configuration__c> ACRRIMap = new Map<String, ACR_Roles_Configuration__c>();
          for (ACR_Roles_Configuration__c ACRRolesConfig : ACRRolesConfigList) {
            ACRRIMap.put (ACRRolesConfig.API_Name__c, ACRRolesConfig);
          }
          
          
          for (String roleString :Rolesplit) {
              /*
              String[] roleStringItems=roleString.split('#');
              string roleLabel = roleStringItems[0];
              string roleCode = roleStringItems[1];
              integer rolePriority = integer.valueof(roleStringItems[2]);
              */

              system.debug ('====== roleString : ' + roleString);

              ACR_Roles_Configuration__c ACRRItmp = ACRRIMap.get(roleString);
              string roleCode = '';
              integer rolePriority =0;
              if (ACRRItmp <> null) {
                roleCode = string.valueof ( ACRRItmp.SAP_Code__c );
                rolePriority= integer.valueof( ACRRItmp.Priority__c );
              } 

              doCreateContact = false;
              
              //system.debug ('=== roleStringItems : ' +  roleStringItems);
              //system.debug ('=== roleLabel : ' +  roleLabel);
              system.debug ('=== roleCode : ' +  roleCode);
              system.debug ('=== rolePriority : ' +  rolePriority);
              system.debug ('=== rolePriorityChoosed  before : ' +  rolePriorityChoosed);
              
              //-- kirim contact yang role priority nya bukan 0 (1, 2, dst)
              if (rolePriority <> 0 ) {
                  if (rolePriorityChoosed == 0 ) {
                      rolePriorityChoosed = rolePriority ;
                      doCreateContact =true;
                  } else if (rolePriority < rolePriorityChoosed ) {
                      //-- jika priority lebih tinggi maka gunakan yang lebih tinggi
                      rolePriorityChoosed = rolePriority;
                      doCreateContact =true;
                  }
                  
                  If (doCreateContact ==true) {
                      Contact=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037();
                      
                      //--tutup dulu Contact.Task='I';
                      if (ACRMode == '' || ACRMode == null)
                          Contact.Task='I';
                      else Contact.Task=ACRMode;
                      
                      if(contactObj.PIC_ID__c==null)
                          contactObj.PIC_ID__c='';
                      
                      Contact.ContactId=contactObj.id;//C[0].PIC_ID__c;
                      
                      if(contactObj.firstname==null)
                          contactObj.firstname='';

                      if(contactObj.department==null)
                          contactObj.department='';

                      if(contactObj.phone==null)
                          contactObj.phone='';

                      if(contactObj.mobilephone==null)
                          contactObj.mobilephone='';

                      if(contactObj.email==null)
                          contactObj.email='';

                      Contact.Firstname=contactObj.firstname;//'cp first name';
                      Contact.Lastname=contactObj.lastname;//'cp last name';
                      Contact.Function='';
                      Contact.Department = roleCode;
                      Contact.Telephone=contactObj.phone;//'021-55667788';
                      Contact.Handphone=contactObj.mobilephone;//'0818993322';
                      Contact.Email=contactObj.email;//'dediw@xl.co.id';
                      
                  }
              }
              system.debug ('=== rolePriorityChoosed  after : ' +  rolePriorityChoosed);

          }
          system.debug ('=== Contact : ' +  Contact);

          if(Contact != null)
              listContact.add(Contact); 
        
        sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00037 PackageContact=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdtt00037();
        PackageContact.item=listContact;
        sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00036 PackageAddress=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00036();
        PackageAddress.item=listAccountAddress;
        sapComDocumentSapSoapFunctionsMcSHANA.ZBD_SF_CUSTOMER_MASTER Master=new sapComDocumentSapSoapFunctionsMcSHANA.ZBD_SF_CUSTOMER_MASTER();
        sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00038 result=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00038();
        
        //prepare to hit to SAP
        Master.inputHttpHeaders_x = new Map<String,String>();
        Master.timeout_x = 120000; //-- set timeout to 2 minutes (December 13, 2021 by doddy)


        String username = system.label.SAPUsername;//'xlsapint';//'P2001211266';
        String password = apputils.doDecrypt(system.label.SAPPassword);//'jakarta03';//'M@nt4pXL';
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
        Master.inputHttpHeaders_x.put('Authorization',authorizationHeader);
        Master.inputHttpHeaders_x.put('Content-Type', 'text/xml');
        try{
            result=Master.ZsfCustomerMaster(PackageAddress,PackageContact,Account);
            list<sapComDocumentSapSoapFunctionsMcSHANA.Zexdsdst00097> msg=new list<sapComDocumentSapSoapFunctionsMcSHANA.Zexdsdst00097>();
            sapComDocumentSapSoapFunctionsMcSHANA.Zexdsdtt00052 rslt=new sapComDocumentSapSoapFunctionsMcSHANA.Zexdsdtt00052();
            list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00038> listitem=new list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00038>();
            listitem=result.Item;
            rslt=listitem[0].Messages;
            msg=rslt.item;
            
            if(listitem[0].IsError=='')
                  status = 'Success';
              else if(listitem[0].IsError=='X')
                  status = 'Failed';  
            
            update settings;
        }
        
        catch(exception e)
        {
            status = 'Failed';
            errMessage =  ' :: error message : ' + e.getmessage() 
                  + ' :: StacktraceString : ' + e.getstacktraceString() 
                  + ' :: LineNumber : ' + e.getLineNumber() 
                  + ' :: Cause  : ' + e.getcause();
            
            update settings;
        }
        
        Call_Log__c CL=new Call_Log__c();
        CL.Request_Start_Time__c = startTime;
        CL.CallerFrom__c  = 'Salesforce';
        CL.endpoint__c = Master.endpoint_x;
        CL.status__c = status;
        /*
        CL.Request_Message__c=String.valueof(' %% Contact : ' + JSON.serialize(PackageContact)
                                             + ' %%  AccountAddress : ' + JSON.serialize(PackageAddress)
                                             + ' %%  Account : '+ JSON.serialize(Account) );
        */
        CL.Request_Message__c=String.valueof('{ "Contact" :' + JSON.serialize(PackageContact) + ', '
                                               + ' "AccountAddress" : ' + JSON.serialize(PackageAddress)  + ', '
                                               + ' "Account" : '+ JSON.serialize(Account) + ' }'  );
        
        //CL.response_message__c=String.valueof(msg[0]);
        CL.response_message__c=String.valueof(JSON.serialize(result) );
        CL.error_message__c = errMessage;
        CL.response_end_time__c=system.now();
        CL.Type__c='Callout';
        insert CL; 
        
    }
}

  @future(callout=true) 
  public static void DeleteContact(String ContactID,String AccountID,String Role, String ACRMode)
  { 
      Datetime startTime = system.now();
      String status = '';
      String errMessage = '';
      
      list<Contact> contactList =[SELECT id,PIC_ID__c,Accountid,Name,firstname,lastname,email,mobilephone,phone,department FROM Contact WHERE ID=:Contactid];
      
      if(contactList.size()>0)
      {
          Contact contactObj = contactList[0];
          
          Account accountObj =[Select Name,BP_Number__c,No_NPWP__c,Customer_type__c from Account WHERE ID=:accountid];
          sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00036 AccountAddress=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00036();
          list<sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00036> listAccountAddress=new list<sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00036>();
          //  listAccountAddress.add(AccountAddress);
          sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00035 Account=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00035();
          Account.Task='P';
          Account.CustomerId='0000'+ accountObj.BP_Number__c;
          String TransactionDay=String.valueof(system.today().day());
          if(TransactionDay.length()==1)
              TransactionDay='0'+TransactionDay;
          String TransactionMonth=String.valueof(system.today().month());
          if(TransactionMonth.length()==1)
              TransactionMonth='0'+TransactionMonth;
          String TransactionDate=String.valueof(system.today().year())+transactionmonth+transactionday;
          Account.TransactionDate=TransactionDate;
          Transaction__c settings = Transaction__c.getOrgDefaults();
          Account.TransactionId=String.valueof(settings.transactionID__c);//'01234567';
          settings.transactionID__c= settings.transactionID__c+1;
          Account.VatNo=accountObj.No_NPWP__C;//'6655778899';
          Account.CustomerClass='';//'01';
          Account.CustomerType=accountObj.Customer_type__c;//'ENC';
          Account.Resv1='';
          if(!Role.Contains(';'))
              Role=Role+';';
          String[] RoleSplit=Role.split(';');
          list<sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00037> listContact=new list<sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00037>();
          
          //-- OLD WAY
          /*
for(String R:Rolesplit)
{
sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00037 Contact=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00037();
Contact.Task='D';
if(C[0].PIC_ID__c==null)
C[0].PIC_ID__c='';
Contact.ContactId=C[0].id;//C[0].PIC_ID__c;
if(C[0].firstname==null)
C[0].firstname='';
if(C[0].department==null)
C[0].department='';
if(C[0].phone==null)
C[0].phone='';
if(C[0].mobilephone==null)
C[0].mobilephone='';
if(C[0].email==null)
C[0].email='';
Contact.Firstname=C[0].firstname;//'cp first name';
Contact.Lastname=C[0].lastname;//'cp last name';
Contact.Function='';
if(R=='PIC UP Invoice')
{
Contact.Department='0018';
}
if(R=='PIC BA Recipient')
{
Contact.Department='0016';
}
if(R=='PIC BA Print')
{
Contact.Department='0017';
}
if(R=='PIC BA Sign')
{
Contact.Department='0019';
}
if(R=='PIC Site'||R=='Contact Person') 
{
Contact.Department='0012';
}
Contact.Telephone=C[0].phone;//'021-55667788';
Contact.Handphone=C[0].mobilephone;//'0818993322';
Contact.Email=C[0].email;//'dediw@xl.co.id';
if(Contact.Department!='')
listContact.add(Contact);
}
*/
          
          /** NEW WAY --------------------------------------------------------
              * send Contact to SAP for some ROLE only
              * August 28, 2020
              * by doddy
              * 
              * check to ROLE API name, sample : PIC Print Invoice#0020#1
              * 1. Role Name (PIC Print Invoice)
              * 2. Role / SAP Department Code (0020)
              * 3. Priority. 0 : avoid / no priority, 1 : first priority, 
              * If a contact have some ROLE that have priority 1 and 2 then just send for priority 1
              * If a contact have some ROLE that have priority 2 and 3 then just send for priority 2 
              * 
              **/
          
          integer rolePriorityChoosed = 0;
          boolean doCreateContact = false;
          sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037 Contact = new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037();

          list<ACR_Roles_Configuration__c> ACRRolesConfigList =  [select Name, API_Name__c, SAP_Code__c, Priority__c from ACR_Roles_Configuration__c ];
          system.debug ('====== ACRRolesConfigList : ' + ACRRolesConfigList);

          Map<String, ACR_Roles_Configuration__c> ACRRIMap = new Map<String, ACR_Roles_Configuration__c>();
          for (ACR_Roles_Configuration__c ACRRolesConfig : ACRRolesConfigList) {
            ACRRIMap.put (ACRRolesConfig.API_Name__c, ACRRolesConfig);
          }
          
          for (String roleString :Rolesplit) {
              /*
              String[] roleStringItems=roleString.split('#');
              string roleLabel = roleStringItems[0];
              string roleCode = roleStringItems[1];
              integer rolePriority = integer.valueof(roleStringItems[2]);
              */

              system.debug ('====== roleString : ' + roleString);

              ACR_Roles_Configuration__c ACRRItmp = ACRRIMap.get(roleString);
              string roleCode = '';
              integer rolePriority =0;
              if (ACRRItmp <> null) {
                roleCode = string.valueof ( ACRRItmp.SAP_Code__c );
                rolePriority= integer.valueof( ACRRItmp.Priority__c );
              }  


              doCreateContact = false;
              
              //system.debug ('=== roleStringItems : ' +  roleStringItems);
              //system.debug ('=== roleLabel : ' +  roleLabel);
              system.debug ('=== roleCode : ' +  roleCode);
              system.debug ('=== rolePriority : ' +  rolePriority);
              system.debug ('=== rolePriorityChoosed  before : ' +  rolePriorityChoosed);
              
              //-- kirim contact yang role priority nya bukan 0 (1, 2, dst)
              if (rolePriority <> 0 ) {
                  if (rolePriorityChoosed == 0 ) {
                      rolePriorityChoosed = rolePriority ;
                      doCreateContact =true;
                  } else if (rolePriority < rolePriorityChoosed ) {
                      //-- jika priority lebih tinggi maka gunakan yang lebih tinggi
                      rolePriorityChoosed = rolePriority;
                      doCreateContact =true;
                  }
                  
                  If (doCreateContact ==true) {
                      Contact=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037();
                      
                      //--tutup dulu Contact.Task='I';
                      if (ACRMode == '' || ACRMode == null)
                          Contact.Task='I';
                      else Contact.Task=ACRMode;
                      
                      if(contactObj.PIC_ID__c==null)
                          contactObj.PIC_ID__c='';
                      
                      Contact.ContactId=contactObj.id;//C[0].PIC_ID__c;
                      
                      if(contactObj.firstname==null)
                          contactObj.firstname='';

                      if(contactObj.department==null)
                          contactObj.department='';

                      if(contactObj.phone==null)
                          contactObj.phone='';

                      if(contactObj.mobilephone==null)
                          contactObj.mobilephone='';

                      if(contactObj.email==null)
                          contactObj.email='';

                      Contact.Firstname=contactObj.firstname;//'cp first name';
                      Contact.Lastname=contactObj.lastname;//'cp last name';
                      Contact.Function='';
                      Contact.Department = roleCode;
                      Contact.Telephone=contactObj.phone;//'021-55667788';
                      Contact.Handphone=contactObj.mobilephone;//'0818993322';
                      Contact.Email=contactObj.email;//'dediw@xl.co.id';
                      
                  }
              }
              system.debug ('=== rolePriorityChoosed  after : ' +  rolePriorityChoosed);

          }
          system.debug ('=== Contact : ' +  Contact);

          if(Contact != null)
              listContact.add(Contact);            
          
          sapComDocumentSapSoapFunctionsMCShana.Zcrmsdtt00037 PackageContact=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdtt00037();
          PackageContact.item=listContact;
          sapComDocumentSapSoapFunctionsMCShana.Zcrmsdtt00036 PackageAddress=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdtt00036();
          PackageAddress.item=listAccountAddress;
          sapComDocumentSapSoapFunctionsMCShana.ZBD_SF_CUSTOMER_MASTER Master=new sapComDocumentSapSoapFunctionsMCShana.ZBD_SF_CUSTOMER_MASTER();
          sapComDocumentSapSoapFunctionsMCShana.Zcrmsdtt00038 result=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdtt00038();
          Master.inputHttpHeaders_x = new Map<String,String>();
          Master.timeout_x = 120000; //-- set timeout to 2 minutes (December 13, 2021 by doddy)

          String username = system.label.SAPUsername;//'xlsapint';
          String password = apputils.doDecrypt(system.label.SAPPassword);//'jakarta03';
          Blob headerValue = Blob.valueOf(username + ':' + password);
          String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
          Master.inputHttpHeaders_x.put('Authorization',authorizationHeader);
          Master.inputHttpHeaders_x.put('Content-Type', 'text/xml');
          try{
              result=Master.ZsfCustomerMaster(PackageAddress,PackageContact,Account);
              list<sapComDocumentSapSoapFunctionsMCShana.Zexdsdst00097> msg=new list<sapComDocumentSapSoapFunctionsMCShana.Zexdsdst00097>();
              sapComDocumentSapSoapFunctionsMcShana.Zexdsdtt00052 rslt=new sapComDocumentSapSoapFunctionsMcShana.Zexdsdtt00052();
              list<sapComDocumentSapSoapFunctionsMcShana.Zcrmsdst00038> listitem=new list<sapComDocumentSapSoapFunctionsMcShana.Zcrmsdst00038>();
              listitem=result.Item;
              rslt=listitem[0].Messages;
              msg=rslt.item;
              
              if(listitem[0].IsError=='')
                  status = 'Success';
              else if(listitem[0].IsError=='X')
                  status = 'Failed';
              
              update settings;
          }
          catch(exception e)
          {
              status = 'Failed';
              errMessage =  ' :: error message : ' + e.getmessage() 
                  + ' :: StacktraceString : ' + e.getstacktraceString() 
                  + ' :: LineNumber : ' + e.getLineNumber() 
                  + ' :: Cause  : ' + e.getcause();
              
              update settings;
          }
          
          
          //-- PUT CALL LOG
          Call_Log__c CL=new Call_Log__c();
          CL.Request_Start_Time__c = startTime;
          CL.CallerFrom__c  = 'Salesforce';
          CL.endpoint__c = Master.endpoint_x;
          CL.status__c = status;
          
          /*
          CL.Request_Message__c=String.valueof(' %% Contact : ' + JSON.serialize(PackageContact)
                                               + ' %%  AccountAddress : ' + JSON.serialize(PackageAddress)
                                               + ' %%  Account : '+ JSON.serialize(Account) );
          */
          CL.Request_Message__c=String.valueof('{ "Contact" :' + JSON.serialize(PackageContact) + ', '
                                               + ' "AccountAddress" : ' + JSON.serialize(PackageAddress)  + ', '
                                               + ' "Account" : '+ JSON.serialize(Account) + ' }'  );            
          
          //CL.response_message__c=String.valueof(msg[0]);
          CL.response_message__c=String.valueof(JSON.serialize(result) );
          CL.error_message__c = errMessage;
          CL.response_end_time__c=system.now();
          CL.Type__c='Callout';
          insert CL;
          
      }
  }
/*
   @future(callout=true) 
  public static void InsertAccount(String AccountID)
  {
  list<Account> A=[SELECT id,Unique_Name__c,Name,keyword__c,BillingCity,BillingStreet,billingstate,BillingPostalCode,ShippingCity,ShippingStreet,shippingstate,ShippingPostalCode,Relocation_Street_1__c,Relocation_Street_2__c,Relocation_Street_3__c,Relocation_Postal_Code__c,Relocation_Region__c,Relocation_City__c,Relocation_Country__c,
  No_NPWP__c,Segmentation_Formula__c,Customer_type__c,BP_Number__c,Customer_vat_name_2__c,OwnerID,term_of_payment__c,la_number__c,Customer_VAT_Name__c FROM Account WHERE ID=:AccountID];
   
      if(A.size()>0)
      {
      //Account A=[Select Name from Account WHERE ID=:C[0].accountid];
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036 AccountAddress=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036();
      AccountAddress.Task='I';
       AccountAddress.AddressType='G';
       String Name40='';
       String UniqueName40='';
       if(A[0].Name.length()>40)
       Name40=A[0].Name.Substring(0,40);
       else
       Name40=A[0].Name;
       if(A[0].Unique_Name__c!=null)
       {
        if(A[0].Unique_Name__c.length()>40)
       UniqueName40=A[0].Unique_Name__c.Substring(0,40);
       else
       UniqueName40=A[0].Unique_Name__c;
       }
    AccountAddress.CustomerName1=Name40;//'GEN name 1';
       AccountAddress.CustomerName2=UniqueName40;
     AccountAddress.CustomerName3='';//'GEN name 3';
       AccountAddress.CustomerName4='';//'GEN name 4';
       AccountAddress.SearchTerm1=A[0].keyword__c;//'GEN name';
      /* Decimal LengthBillingStreet=A[0].billingStreet.length();
      
        if(lengthBillingStreet<60)
        AccountAddress.Street1=A[0].BillingStreet;
        if(lengthBillingStreet>=60)
       {  AccountAddress.Street1=A[0].BillingStreet.Substring(0,59);
           if(lengthBillingStreet>98)
    {    AccountAddress.Street2=A[0].BillingStreet.substring(59,98);
          AccountAddress.Street3=A[0].BillingStreet.substring(98);
    }
          else
           AccountAddress.Street2=A[0].BillingStreet.substring(59);
        }
          
          list<String> Street=new list<String>();
          Street=AddressConvert(A[0].BillingStreet,60,40,40);
          AccountAddress.Street1=Street[0];
          AccountAddress.Street2=Street[1];
           AccountAddress.Street3=Street[2];
     
       AccountAddress.City=A[0].BillingCity;//'Jakarta';
       AccountAddress.HouseNo='';//'88';
       AccountAddress.Region='';//A[0].billingstate;//'10';
       AccountAddress.PostalCode='';//A[0].BillingPostalCode;
       AccountAddress.Country='ID';//'ID';
       sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036 AccountAddress2=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036();
            AccountAddress2.Task='I';
       AccountAddress2.AddressType='Z';
    AccountAddress2.CustomerName1=A[0].Customer_Vat_Name__c;//'GEN name 1';
       AccountAddress2.CustomerName2=A[0].Customer_Vat_Name_2__c;//A[0].Unique_Name__c;
     AccountAddress2.CustomerName3='';//'GEN name 3';
       AccountAddress2.CustomerName4='';//'GEN name 4';
       AccountAddress2.SearchTerm1=A[0].keyword__c;//'GEN name';
       if(A[0].ShippingStreet!=null)
       {
          Street=AddressConvert(A[0].ShippingStreet,60,40,40);
          AccountAddress2.Street1=Street[0];
          AccountAddress2.Street2=Street[1];
          AccountAddress2.Street3=Street[2];
       }
       AccountAddress2.City=A[0].ShippingCity;//'Jakarta';
       AccountAddress2.HouseNo='';//'88';
       AccountAddress2.Region='';//A[0].shippingstate;//'10';
       AccountAddress2.PostalCode='';//A[0].ShippingPostalCode;//'15144';
       AccountAddress2.Country='ID';//'ID';       
      list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036> listAccountAddress=new list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036>();
      listAccountAddress.add(AccountAddress);
         if(A[0].ShippingStreet!=null)
       listAccountAddress.add(AccountAddress2);
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00035 Account=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00035();
      Transaction__c settings = Transaction__c.getOrgDefaults();
    
      Account.Task='I';
        if(A[0].Term_of_Payment__c!=null && A[0].term_of_payment__c!='')
      Account.RESV1=A[0].term_of_payment__c.substring(0,4);
      Account.CustomerId='';//'0000'+A[0].BP_Number__c;
      String TransactionDay=String.valueof(system.today().day());
      if(TransactionDay.length()==1)
       TransactionDay='0'+TransactionDay;
      String TransactionMonth=String.valueof(system.today().month());
       if(TransactionMonth.length()==1)
       TransactionMonth='0'+TransactionMonth;
      String TransactionDate=String.valueof(system.today().year())+transactionmonth+transactionday;
      Account.TransactionDate=TransactionDate;
     
         Account.TransactionId=String.valueof(settings.transactionID__c);//'01234567';
        settings.transactionID__c= settings.transactionID__c+1;
   

        Account.VatNo=A[0].No_NPWP__c;//'6655778899';
       Account.CustomerClass='';
      Account.CustomerType=A[0].Customer_type__c;
      
       User U=[SELECT id,employee_id__c,firstname,lastname,email,mobilephone,phone from user WHERE Id=:A[0].ownerid];
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037 Contact=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037();
       list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037> listContact=new list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037>();
   
      if(A[0].LA_Number__c!='' && A[0].LA_Number__c!=null)
      {
      Contact.Task='I';
       Contact.LastName=A[0].La_Number__c;
       Contact.Department='0015';
       Contact.Firstname='';
       Contact.Function='';
       Contact.Email='';
       Contact.Telephone='';
       Contact.Handphone='';
       listContact.add(Contact);
      }
        
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00037 PackageContact=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00037();
      PackageContact.item=listContact;
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00036 PackageAddress=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00036();
      PackageAddress.item=listAccountAddress;
      sapComDocumentSapSoapFunctionsMCS2.ZBD_SF_CUSTOMER_MASTER Master=new sapComDocumentSapSoapFunctionsMCS2.ZBD_SF_CUSTOMER_MASTER();
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00038 result=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00038();
   
      //  Master.clientCert_x='MIIFVzCCBD+gAwIBAgIQBaSeWyou+UIIoQL7ph10ZTANBgkqhkiG9w0BAQsFADBwMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMS8wLQYDVQQDEyZEaWdpQ2VydCBTSEEyIEhpZ2ggQXNzdXJhbmNlIFNlcnZlciBDQTAeFw0xNjA2MDYwMDAwMDBaFw0xODA2MTExMjAwMDBaMGsxCzAJBgNVBAYTAklEMRQwEgYDVQQIEwtES0kgSmFrYXJ0YTEQMA4GA1UEBxMHSmFrYXJ0YTESMBAGA1UEChMJWEwgQXhpYXRhMSAwHgYDVQQDExdlLXN1cHBsaWVybWdtdC54bC5jby5pZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPzaXIW+lLNcOyiVlVlPZg5ZUqFbOPbSq7Yv3smdsmUVM+Nt1NpBQKErbs0ZVQbhJOvCT+HCUsmJtC5dQBJFy6c00OaSuRS87ggsLGy9ZIztG53cHdysZBi8wXg1oXZFHHRJxp3u56lJWZa3jCV9pGdso7u07S3v2euRVJ+jMfNLS31PnnBYMcAXDXRNzw8h20K5g68RwXJG4InDweKd5pq2nV/PyvcLGTSDISV/otD4Ai0QL3S/iq4OVzKklnWE0V1ujWmrrcBeLmkUCtRbuKbGaESxJ0FJg3zhuZjUm5MBJWpsfBN5HKqaklrQGfEAQOHyDmJCEhHFqWIv4cO+XTMCAwEAAaOCAfAwggHsMB8GA1UdIwQYMBaAFFFo/5CvAgd1PMzZZWRiohK4WXI7MB0GA1UdDgQWBBSjBIKr3K1x8Z96UJVQHd0VoZ6eLjAiBgNVHREEGzAZghdlLXN1cHBsaWVybWdtdC54bC5jby5pZDAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMHUGA1UdHwRuMGwwNKAyoDCGLmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9zaGEyLWhhLXNlcnZlci1nNS5jcmwwNKAyoDCGLmh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWhhLXNlcnZlci1nNS5jcmwwTAYDVR0gBEUwQzA3BglghkgBhv1sAQEwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAIBgZngQwBAgIwgYMGCCsGAQUFBwEBBHcwdTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tME0GCCsGAQUFBzAChkFodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRTSEEySGlnaEFzc3VyYW5jZVNlcnZlckNBLmNydDAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBCwUAA4IBAQBQbp1pGM9T4EGEwGqqHMYFX+a2+TUTzcAj98zyVnyeUliSD1FHl/Zadtpkl9O8NL7ZIiVOvuk33UL1Y+DZtqQBqqOJWTCbB5ZXl6/C1Ag8EVQ6lQAGevMb6RUffCUVmBZ9J4tk4pg2yCTgvp9kiuH8PzyVavupQ/WRvAV2lodtxOydzj3+wPE8J+w6p8sbNnczMcRVzc0GB3j5Ix13tDFwlK73Bdcc4pDbjW3qB1FeGE760X6PybTrOrmuvGxkIVpm0S4WGZoy0elM0bMKqSkwjfCj8Hp8njIaJPqJULvGVdcHFCPJMDPIeWpQhgGy8hk89Jv2HviNTV/NRb3IJvTX';
      //  Master.clientCert_x='MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQD82lyFvpSzXDsolZVZT2YOWVKhWzj20qu2L97JnbJlFTPjbdTaQUChK27NGVUG4STrwk/hwlLJibQuXUASRcunNNDmkrkUvO4ILCxsvWSM7Rud3B3crGQYvMF4NaF2RRx0Scad7uepSVmWt4wlfaRnbKO7tO0t79nrkVSfozHzS0t9T55wWDHAFw10Tc8PIdtCuYOvEcFyRuCJw8Hineaatp1fz8r3Cxk0gyElf6LQ+AItEC90v4quDlcypJZ1hNFdbo1pq63AXi5pFArUW7imxmhEsSdBSYN84bmY1JuTASVqbHwTeRyqmpJa0BnxAEDh8g5iQhIRxaliL+HDvl0zAgMBAAECggEAWJtUzPGKPohVmtVAbvmp8+FNWYoUHjqZPdDsq459k3qookw8yPcQ5OnJfEoiR7TiMVP4lk54oHOHFrBK4Zxfz4psokBMZ34FlAuWzcxYziHCbK3LDulIB4VVkDFAiMZ445u8a1ktSglIvHTRNgQosWpYv/2FaD1pt1Y4FBaEr1ft9kEG3y9ywGD6woK6E7U3E8ZKSljWzw5TLtuRF1iKWsgJiqet9lwVTuyhzbc8MVuN2qJuizGuyzqmDerl1yH1ODTTsv3NwmHny94AmFYa6yDrh1CYACrB+IyPaZIBaBh6KSKgWLpSsIq3V5R7MsJgNUSpnpAz0mvYMbbrS9UEQKBgQD9p9hLd3Q4WH+S8SzJH51Ree4cxKrjIYFgJNscjxyXWTMFa2ea18A3Ddb34kLYC71y5AO1YLg8Ol74VfpFlJpuCaS3yL+LIpfEfowbmBPTdceHemlX6CM7kF97mas9A18zdFvi+2cxKBNZAyDd8MRsUiuVqzkWuU2pVvwwXhcJQKBgQD/MJ4Milkomn8Iw1A4RWszDHTuH/ILAfet0X5tSCOgBHtCsFAlNx9z961BmOtfkEElzccbp+uQFeBlsYu8vAE2HYbYXnHhDv4SWPYluxtqoQt5645ztfmLNMpYP4ZTQZpghj1so5Mjiej+8bZgG9yaq4nsopdN7x5ZySGnFQLodwKBgDzqoURGdM/PWRv19ZZ7lDFsAeZAyPVxJ3vqfgCW0fv6/QjRKXmDVPMjzLuNSBZQg3fjEIzvpG86aXJkW5ExoisngYQGOIYoNjbsv1QAPfrtq7rc3i7MD2epFGtk5J2motKVLzYFudPLWOAdJfAww9Us6VKNGEpjFecQwUrJe9lNAoGBAOY3Au5HRSXXMvFB2jXZklsMStSj5yS9Eqcxjj+iS9lJEbXY/4SDVRG2iAvcm8Krjco/+PbfJyjmQ3kakfijFuit/H9nvI6PivAcZ3skcBhizsqfkfSbX1ORPVYdgN3NGisoD3PZoZz3BkYw4xmTKRIz3IqpJ5x8MsJHK9/imawDAoGBAKl3xkefFrlawauDrymhkfFw23WuCxsyzCFgefIGfajkp9qLyAsFhmPYPEfeSzmGnDdOAeKXxUWrv3VWJaWoKulJcU9vnvyF4/xcSVvopb51ZgCvKfj6bW7sT2ntKXfbIm/Y8Jkj9/ls6XUWPXZf8j6JDfBrA02ec8HaCkkDiJ/p';           
//  String PK=EncodingUtil.base64Encode('舰Ўआ蘪虈෷܁ꀂංヵං˱ā1ରआ蘪虈෷܁ꀁංベւし҂ꀿȃȁဂꐅ实⸪䋹ꄈﬂᶦ整രआ蘪虈෷āԋ　ㅰ》؉唃؄ȓ单ᔱጰ̆ѕጊ䐌杩䍩牥⁴湉ㅣ〙ؗ唃଄ဓ睷⹷楤楧散瑲挮浯⼱ⴰ̆ѕጃ䐦杩䍩牥⁴䡓㉁䠠杩⁨獁畳慲据⁥敓癲牥䌠ぁ᜞ㄍ〶〶〶〰〰娰ഗ㠱㘰ㄱ㈱〰〰ずㅫ》؉唃؄ȓ䑉ᐱሰ̆ѕገ䐋䥋䨠歡牡慴ေะ̆ѕጇ䨇歡牡慴ሱူ̆ѕጊ堉⁌硁慩慴‱Ḱ̆ѕጃ攗猭灵汰敩浲浧⹴汸挮⹯摩舰∁രआ蘪虈෷āԁ̀Ƃ舰ਁ舂āﰀ峚뺅뎔㭜锨妕晏夎ꅒ㡛틶뚫?鷉斲㌕淣?䁁⮡쵮唙係싡쥒뒉崮ቀ쭅㒧릒바࣮Ⱜ뵬豤ᯭ??撬반磁ꄵ䕶琜왉ꧧ奉랖▌ꑽ汧뮣咑ꎟ䭋佽炞ㅘៀ琍콍ℏ䋛莹ᆯ狁쎉뚚徝쫏௷㐙Ↄ缥킢˸ိ琯調ຮ㉗隤葵巑赮ꭩ삭⹞ᑩ퐊롛욦䑨➱䥁粃맡풘鎛━汪፼ᱹ骪媒᧐ñ໲䉢ᄒ꧅⽢쏡嶾ȳăĀ芣舰ἰ̆ᵕУ〘耖儔ｨ꾐܂㱵?摥ꉢ렒牙〻؝唃ฝᘄᐄңꮂ규窟镐ᵐᗝ麡⺞∰̆ᵕБ〛舙攗猭灵汰敩浲浧⹴汸挮⹯摩ะ̆ᵕď！Єȃꀅᴰ̆ᵕХ〖ؔ⬈Ćԅ̇؁⬈Ćԅ̇。ٵ唃Ἕ渄氰㐰㊠゠⺆瑨灴⼺振汲⸳楤楧散瑲挮浯猯慨ⴲ慨猭牥敶⵲㕧挮汲㐰㊠゠⺆瑨灴⼺振汲⸴楤楧散瑲挮浯猯慨ⴲ慨猭牥敶⵲㕧挮汲䰰̆ᵕРぅぃط怉䢆蘁泽ā⨰⠰ࠆثԁ܅Ăᰖ瑨灴㩳⼯睷⹷楤楧散瑲挮浯䌯卐࠰؆腧ČȂ脰ڃ⬈ĆԅćЁぷふؤ⬈Ćԅ〇蘁栘瑴㩰⼯捯灳搮杩捩牥⹴潣ねٍ⬈Ćԅ〇蘂桁瑴㩰⼯慣散瑲⹳楤楧散瑲挮浯䐯杩䍩牥却䅈䠲杩䅨獳牵湡散敓癲牥䅃挮瑲ర̆ᵕē！Ȅ0രआ蘪虈෷āԋ̀Ƃ湐榝켘葁櫀Ც׆禮ጵ샍籖办鉘儏靇嫶?靤볓븴⋙严?뛙Ƥꎪ妉鬰阇靗슯ࣔᄼ㩔稆᯳ᗩ簟ᔥᚘ❽撋飢젶龾詤ﳡ㰿檕ꧻ벑瘅螖쑭鷬㷎샾㳱Ꜻᯋ眶ㄳ嗄췍܆兩ᴣ둷瀱꺔׷᳗郢跛儇ᡞ祈绑즏뤺벮摬娡텦ᘮ騙턲䳩돑ꤊ〩籺㊞␚觺뭐嗆ߗ⌔ド젳橹虐눁᧲䶍쵟뵅⛈ퟴ舰씃舰괂ΠĂȂȐ岬樦䀋辛礋껲╆ぷ؍⨉䢆čԁ氰଱र̆ѕጆ唂ㅓ〕ؓ唃਄ఓ楄楧敃瑲䤠据ᤱᜰ̆ѕጋ眐睷搮杩捩牥⹴潣ㅭ〫ة唃̄∓楄楧敃瑲䠠杩⁨獁畳慲据⁥噅删潯⁴䅃Ḱഗ㘰ㄱ〱〰〰〰᝚㌍ㄱㄱ〰〰〰娰氰଱र̆ѕጆ唂ㅓ〕ؓ唃਄ఓ楄楧敃瑲䤠据ᤱᜰ̆ѕጋ眐睷搮杩捩牥⹴潣ㅭ〫ة唃̄∓楄楧敃瑲䠠杩⁨獁畳慲据⁥噅删潯⁴䅃舰∁രआ蘪虈෷āԁ̀Ƃ舰ਁ舂ā였퓻ⴭ꘲㾁췉䤥熶쌪铕朴ઢ뀜楟䂦쒱늷킏꒘䆩㩙?횔?㡴䪤䷌舥䫷厥㠒浉酱捾ꮶ徦꓃扏빑엸?鈸ۣࣥ಑⣄啁쯻襚縕뼵牍㴉㪾倸睛ᬱ뎍Ⓡ驅겧m娔뜄Ꮊ凫頊䅁丢慥膇偁禦襜᧞坊⻕左匜縬춘ؚꐖ獨㓐ጄꅜ퍱籚?摞㟡ょіᇥ⦴ኀ秱蠹ʢ簑昧袷碷쫲ꠊꬸ搊뿂嵦蒕ꇁḥ嶇倚​찒뭁୮㡑䮸ˋăĀ掣愰ะ̆ᵕď！Єȃ蘁༰̆ᵕē！Ԅ̰āヿ؝唃ฝᘄᐄ㺱槃䞿퐁⚘ࠚ摣쌫ἰ̆ᵕУ〘耖넔쌾ͩ뿸Ň飔ᨦȈ揯⭤ッ؍⨉䢆čԁ舃āᰀؚ?鳗㲟暈ࠆ⅗⇛未뾪㈘䁶圐諁竳ᇙ蹥卑ﲞ땅?ㅌ롋ⱃ뎎칸祓홱⇥Ɣ嗚骇搤諶챦鳞촷㒨榱⎛黈≸瀫䝕愱았⾅ぎꃶᘱ젣ᙥ쬳ᪿꀛ廊ㆋ悋褈భ将띒龍頊ᗑ齟븒㙼㡣䒽群⛤ਫ韄൩賩샢圐좸ቶ喑䣲?⪼嬂䐏⃔?뫴♰遝鹠䮼ग됯ị桃߉섧峒뤡ቨ㲜뾜ﲞ岀掛ꩇ✥ꁧ舀命꧗ጮ瞣Ῠお҂ケ΂ꂙȃȁဂꓧ峜쁭䈫嶸鼕രआ蘪虈෷āԋ　ㅬ》؉唃؄ȓ单ᔱጰ̆ѕጊ䐌杩䍩牥⁴湉ㅣ〙ؗ唃଄ဓ睷⹷楤楧散瑲挮浯⬱⤰̆ѕጃ䐢杩䍩牥⁴楈桧䄠獳牵湡散䔠⁖潒瑯䌠ぁ᜞ㄍㄳ㈰ㄲ〲〰娰ഗ㠲〱㈲㈱〰〰ずㅰ》؉唃؄ȓ单ᔱጰ̆ѕጊ䐌杩䍩牥⁴湉ㅣ〙ؗ唃଄ဓ睷⹷楤楧散瑲挮浯⼱ⴰ̆ѕጃ䐦杩䍩牥⁴䡓㉁䠠杩⁨獁畳慲据⁥敓癲牥䌠ぁƂ〢؍⨉䢆čā舃༁　ƂȊƂ숯ؤ淈弄搊눆≽攦긖䁂캛鿜皟㸇ッ蝕뤙鑏娎ᾔ噕슴⨂킯䀋쓗㯐졲鸔郯ᆱ꺩죒䎸?ଋ헕꽀᷈䷭徜띗傆饨諵틚ׇꠟ즗ꓜ花ⶄ귆鲥ᧇꚂ྅䑞⩘輷㗽௱✈娲믵麋붤큑㯝㍂֣쐨⢻髌⮬ണ외煞䪷࠾臻ᚷꄖ⎝䴒ퟥ࢒疬鲤춺눗䐞攵卿㤥᳑騊᭣鈙桴㜊싂䡒㧋ꉚ셝ꃝ렠ꈡ⚓ᑯ⅊읁淭⽈ϳꋵ鉨⽓̂ꌁƂぉƂぅؒ唃ጝāӿ〈Ć！Ă　؎唃༝āӿ̄Ăゆ؝唃┝ᘄᐰࠆثԁ܅ăࠆثԁ܅ȃ㐰ࠆثԁ܅ā⠄☰␰ࠆثԁ܅İᢆ瑨灴⼺漯獣⹰楤楧散瑲挮浯䬰̆ᵕПいあꁀꀾ蘼栺瑴㩰⼯牣㑬搮杩捩牥⹴潣⽭楄楧敃瑲楈桧獁畳慲据䕥剖潯䍴⹁牣ぬؽ唃”㘄㐰㈰Іᵕ ⨰⠰ࠆثԁ܅Ăᰖ瑨灴㩳⼯睷⹷楤楧散瑲挮浯䌯卐ᴰ̆ᵕЎЖ儔ｨ꾐܂㱵?摥ꉢ렒牙〻؟唃⌝᠄ᘰᒀ㺱槃䞿퐁⚘ࠚ摣쌫രआ蘪虈෷āԋ̀Ƃ記覕?ﱜ栝䫪莏凖贯䑫鸖掬틵汮馄ꪋ熁宄㓭끎禷⦒ⷌ檀軰ꑹϾፇ쪆煙阄퍫塙︽㇓尥㠘ꎄ鿦ﶂ完㆘쵎鹸ﴚ쮅ꩉ⟲馋ﱲ꨾䇕?㛕뾡渜䥇广䣙ͼ﷙䦋颠䈦鋖ꐑ੤呗혝市걫쓮骀爒固힓뿿蔰〆ி乿埿鴅쎅שׂ疦겨ᘭ緯❹鷂܋ꫪ펅ꌁ⠠奁⡃臒ꫣ㭻뙷所ր䕁ؗ?㏀枛懓爮ﱩ䁗瀞ỵ듉1');
  //  Master.clientCert_x=PK; 
  //      Master.clientCertPasswd_x='S4Padmin';
  Master.inputHttpHeaders_x=new Map<String,String>();
      String username = system.label.SAPUsername;//'xlsapint';
          String password = apputils.doDecrypt(system.label.SAPPassword);//'jakarta03';
Blob headerValue = Blob.valueOf(username + ':' + password);
String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
Master.inputHttpHeaders_x.put('Authorization',authorizationHeader);
Master.inputHttpHeaders_x.put('Content-Type', 'text/xml');
      try{
      result=Master.ZsfCustomerMaster(PackageAddress,PackageContact,Account);
     list<sapComDocumentSapSoapFunctionsMCS2.Zexdsdst00097> msg=new list<sapComDocumentSapSoapFunctionsMCS2.Zexdsdst00097>();
      sapComDocumentSapSoapFunctionsMcS2.Zexdsdtt00052 rslt=new sapComDocumentSapSoapFunctionsMcS2.Zexdsdtt00052();
      list<sapComDocumentSapSoapFunctionsMcS2.Zcrmsdst00038> listitem=new list<sapComDocumentSapSoapFunctionsMcS2.Zcrmsdst00038>();
      listitem=result.Item;
      rslt=listitem[0].Messages;
      if(listitem[0].IsError=='')
      {A[0].BP_Number__c=listitem[0].CustomerID.RIGHT(6);
     update A;}
      msg=rslt.item;
      Call_Log__c CL=new Call_Log__c();
      CL.endpoint__c=Master.endpoint_x;
        CL.Request_Message__c=String.valueof('  Contact'+PackageContact+'  AccountAddress'+PackageAddress+'   Account'+Account);
     
        CL.response_message__c=String.valueof(msg[0]);
   
      CL.response_end_time__c=system.now();
      CL.Type__c='Callout';
      insert CL;
       update settings;
      }
      catch(exception e)
      {
           Call_Log__c CL=new Call_Log__c();
      CL.endpoint__c=Master.endpoint_x;
 //    system.debug(msg[0]);
        CL.response_message__c=e.getmessage();
        CL.Request_Message__c=String.valueof('  Contact'+PackageContact+'  AccountAddress'+PackageAddress+'   Account'+Account);
   // CL.Method__c='SAP';
      CL.response_end_time__c=system.now();
      CL.Type__c='Callout';
      insert CL;
       update settings;
      }
      }
  }
  */
  @future(callout=true) 
  public static void InsertAccount2(String AccountID)
  {
      Datetime startTime = system.now();
      String status = '';
      String errMessage = '';
      
      //map variable to parameter
      list<Account> AccountObj=[SELECT id,Unique_Name__c,Name,keyword__c,BillingCity,BillingStreet,billingstate,BillingPostalCode,ShippingCity,ShippingStreet,shippingstate,ShippingPostalCode,Relocation_Street_1__c,Relocation_Street_2__c,Relocation_Street_3__c,Relocation_Postal_Code__c,Relocation_Region__c,Relocation_City__c,Relocation_Country__c,
                       No_NPWP__c,Segmentation_Formula__c,Customer_type__c,BP_Number__c,Customer_vat_name_2__c,Customer_vat_name_3__c,Customer_vat_name_4__c,OwnerID,Owner.Name,term_of_payment__c,la_number__c,Customer_VAT_Name__c FROM Account WHERE ID=:AccountID];
      
      if(AccountObj.size()>0)
      {
          //Account A=[Select Name from Account WHERE ID=:C[0].accountid];
          sapComDocumentSapSoapFunctionsMCSHANA.Zcrmsdst00036 AccountAddress=new sapComDocumentSapSoapFunctionsMCSHANA.Zcrmsdst00036();
          AccountAddress.Task='I';
          AccountAddress.AddressType='G';
          String Name40='';
          String UniqueName40='';

          if(AccountObj[0].Name.length()>40)
              Name40=AccountObj[0].Name.Substring(0,40);
          else
              Name40=AccountObj[0].Name;
          
          if(AccountObj[0].Unique_Name__c!=null)
          {
              if(AccountObj[0].Unique_Name__c.length()>40)
              UniqueName40=AccountObj[0].Unique_Name__c.Substring(0,40);
              else
              UniqueName40=AccountObj[0].Unique_Name__c;
          }
      
          AccountAddress.CustomerName1=Name40;//'GEN name 1';
          AccountAddress.CustomerName2=UniqueName40;
          AccountAddress.CustomerName3='';//'GEN name 3';
          AccountAddress.CustomerName4='';//'GEN name 4';
          AccountAddress.SearchTerm1=AccountObj[0].keyword__c;//'GEN name';

          /* Decimal LengthBillingStreet=A[0].billingStreet.length();
          
          if(lengthBillingStreet<60)
          AccountAddress.Street1=A[0].BillingStreet;
          if(lengthBillingStreet>=60)
          {  AccountAddress.Street1=A[0].BillingStreet.Substring(0,59);
              if(lengthBillingStreet>98)
      {    AccountAddress.Street2=A[0].BillingStreet.substring(59,98);
              AccountAddress.Street3=A[0].BillingStreet.substring(98);
      }
              else
              AccountAddress.Street2=A[0].BillingStreet.substring(59);
          }
              */

          
          list<String> Street=new list<String>();
          Street=AddressConvert(AccountObj[0].BillingStreet,60,40,40);
          AccountAddress.Street1=Street[0];
          AccountAddress.Street2=Street[1];
          AccountAddress.Street3=Street[2];
      
          AccountAddress.City=AccountObj[0].BillingCity;//'Jakarta';
          AccountAddress.HouseNo='';//'88';
          AccountAddress.Region='';//A[0].billingstate;//'10';
          AccountAddress.PostalCode='';//A[0].BillingPostalCode;
          AccountAddress.Country='ID';//'ID';
          sapComDocumentSapSoapFunctionsMCSHANA.Zcrmsdst00036 AccountAddress2=new sapComDocumentSapSoapFunctionsMCSHANA.Zcrmsdst00036();
          
          AccountAddress2.Task='I';
          AccountAddress2.AddressType='Z';
          AccountAddress2.CustomerName1=AccountObj[0].Customer_Vat_Name__c;//'GEN name 1';
          AccountAddress2.CustomerName2=AccountObj[0].Customer_Vat_Name_2__c;//A[0].Unique_Name__c;
          AccountAddress2.CustomerName3=AccountObj[0].Customer_Vat_Name_3__c;
          AccountAddress2.CustomerName4=AccountObj[0].Customer_Vat_Name_4__c;
          AccountAddress2.SearchTerm1=AccountObj[0].keyword__c;//'GEN name';
          
          if(AccountObj[0].ShippingStreet!=null)
          {
              Street=AddressConvert(AccountObj[0].ShippingStreet,60,40,40);
              AccountAddress2.Street1=Street[0];
              AccountAddress2.Street2=Street[1];
              AccountAddress2.Street3=Street[2];
          }

          AccountAddress2.City=AccountObj[0].ShippingCity;//'Jakarta';
          AccountAddress2.HouseNo='';//'88';
          AccountAddress2.Region='';//A[0].shippingstate;//'10';
          AccountAddress2.PostalCode='';//A[0].ShippingPostalCode;//'15144';
          AccountAddress2.Country='ID';//'ID';       
          list<sapComDocumentSapSoapFunctionsMCSHANA.Zcrmsdst00036> listAccountAddress=new list<sapComDocumentSapSoapFunctionsMCSHANA.Zcrmsdst00036>();
          listAccountAddress.add(AccountAddress);
          
          if(AccountObj[0].ShippingStreet!=null)
              listAccountAddress.add(AccountAddress2);
          
          sapComDocumentSapSoapFunctionsMCSHANA.Zcrmsdst00035 Account=new sapComDocumentSapSoapFunctionsMCSHANA.Zcrmsdst00035();
          Transaction__c settings = Transaction__c.getOrgDefaults();
      
          Account.Task='I';
          if(AccountObj[0].Term_of_Payment__c!=null && AccountObj[0].term_of_payment__c!='')
              Account.RESV1=AccountObj[0].term_of_payment__c.substring(0,4);
          
          Account.CustomerId='';//'0000'+A[0].BP_Number__c;
          String TransactionDay=String.valueof(system.today().day());
          if(TransactionDay.length()==1)
              TransactionDay='0'+TransactionDay;
          
          String TransactionMonth=String.valueof(system.today().month());
          if(TransactionMonth.length()==1)
              TransactionMonth='0'+TransactionMonth;
          
          String TransactionDate=String.valueof(system.today().year())+transactionmonth+transactionday;
          Account.TransactionDate=TransactionDate;
      
          Account.TransactionId=String.valueof(settings.transactionID__c);//'01234567';
          settings.transactionID__c= settings.transactionID__c+1;
      

          Account.VatNo=AccountObj[0].No_NPWP__c;//'6655778899';
          Account.CustomerClass='';
          Account.CustomerType=AccountObj[0].Customer_type__c;
          
          User U=[SELECT id,employee_id__c,firstname,lastname,email,mobilephone,phone from user WHERE Id=:AccountObj[0].ownerid];
          sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037 Contact=new sapComDocumentSapSoapFunctionsMCSHANA.Zcrmsdst00037();
          list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037> listContact=new list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037>();
      
          if(AccountObj[0].LA_Number__c!='' && AccountObj[0].LA_Number__c!=null)
          {
              Contact.Task='I';
              Contact.LastName=AccountObj[0].La_Number__c;
              Contact.Department='0015';
              Contact.Firstname='';
              Contact.Function='';
              Contact.Email='';
              Contact.Telephone='';
              Contact.Handphone='';
              Contact.ContactId = AccountObj[0].LA_Number__c;     //-- tambahan per 12 Nov 2020 by doddy : untuk identifier unique ID
              listContact.add(Contact);
          }
          sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037 Contact2=new sapComDocumentSapSoapFunctionsMCSHANA.Zcrmsdst00037();
      
      
          Contact2.Task='I';
          Contact2.LastName=U.lastname;
          Contact2.Department='0011';
          Contact2.ContactId=U.employee_id__c;
          Contact2.Firstname=U.firstname;
          Contact2.Function='';
          Contact2.Email=U.email;
          Contact2.Telephone=U.phone;
          Contact2.Handphone=U.mobilephone;
          //-- update tanggal 11 Jan 2020 : Ditutup kembali menggunakan employee_id__c
          //Contact2.ContactId = U.id;                 //-- tambahan per 12 Nov 2020 by doddy : untuk identifier unique ID
          listContact.add(Contact2);
          
          
          sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00037 PackageContact=new sapComDocumentSapSoapFunctionsMCSHANA.Zcrmsdtt00037();
          PackageContact.item=listContact;
          sapComDocumentSapSoapFunctionsMCSHANA.Zcrmsdtt00036 PackageAddress=new sapComDocumentSapSoapFunctionsMCSHANA.Zcrmsdtt00036();
          PackageAddress.item=listAccountAddress;
          sapComDocumentSapSoapFunctionsMcSHANA.ZBD_SF_CUSTOMER_MASTER Master=new sapComDocumentSapSoapFunctionsMcSHANA.ZBD_SF_CUSTOMER_MASTER();
          sapComDocumentSapSoapFunctionsMCSHANA.Zcrmsdtt00038 result=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00038();
          
          //prepare to hit SAP
          Master.inputHttpHeaders_x = new Map<String,String>();
          Master.timeout_x = 120000; //-- set timeout to 2 minutes (December 13, 2021 by doddy)

          String username =system.label.SAPUsername;//'xlsapint';//'P2001211266';
          String password = apputils.doDecrypt(system.label.SAPPassword);//'jakarta03';//'M@nt4pXL';
          
          Blob headerValue = Blob.valueOf(username + ':' + password);
          String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
          Master.inputHttpHeaders_x.put('Authorization',authorizationHeader);
          Master.inputHttpHeaders_x.put('Content-Type', 'text/xml');

          try{
          
              result=Master.ZsfCustomerMaster(PackageAddress, PackageContact, Account);
              list<sapComDocumentSapSoapFunctionsMCShana.Zexdsdst00097> msg=new list<sapComDocumentSapSoapFunctionsMCShana.Zexdsdst00097>();
              sapComDocumentSapSoapFunctionsMcSHANA.Zexdsdtt00052 rslt=new sapComDocumentSapSoapFunctionsMcSHANA.Zexdsdtt00052();
              list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00038> listitem=new list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00038>();
              listitem=result.Item;
              rslt=listitem[0].Messages;
              
              if(listitem[0].IsError=='')
                  status = 'Success';
              else if(listitem[0].IsError=='X')
                  status = 'Failed';
              
              msg=rslt.item; 
              
              if (msg[0].MessageNo == '000' )     //-- array pertama dari message List = 'Business Partner ... created Successfully'
              {   AccountObj[0].BP_Number__c=listitem[0].CustomerID.RIGHT(6);
                  update AccountObj;
              }
              
              if(listitem[0].IsError=='')
                  status = 'Success';
              else if(listitem[0].IsError=='X')
                  status = 'Failed';
              
              update settings;
          }

          catch(exception e)
          {
              status = 'Failed';
              errMessage =  ' :: error message : ' + e.getmessage() 
                  + ' :: StacktraceString : ' + e.getstacktraceString() 
                  + ' :: LineNumber : ' + e.getLineNumber() 
                  + ' :: Cause  : ' + e.getcause();
              update settings;
          }
          
          
          Call_Log__c CL=new Call_Log__c();
          CL.Request_Start_Time__c = startTime;
          CL.CallerFrom__c  = 'Salesforce';
          CL.endpoint__c = Master.endpoint_x;
          CL.status__c = status;
          
          /*
          CL.Request_Message__c=String.valueof(' %% Contact : ' + JSON.serialize(PackageContact)
                                               + ' %%  AccountAddress : ' + JSON.serialize(PackageAddress)
                                               + ' %%  Account : '+ JSON.serialize(Account) );
          */
          CL.Request_Message__c=String.valueof('{ "Contact" :' + JSON.serialize(PackageContact) + ', '
                                               + ' "AccountAddress" : ' + JSON.serialize(PackageAddress)  + ', '
                                               + ' "Account" : '+ JSON.serialize(Account) + ' }'  );
          
          //CL.response_message__c=String.valueof(msg[0]);
          CL.response_message__c=String.valueof(JSON.serialize(result) );
          CL.error_message__c = errMessage;
          CL.response_end_time__c=system.now();
          CL.Type__c='Callout';
          insert CL;
      }
  }

/*
    @future(callout=true) 
  public static void UpdateAccount(String AccountID,Boolean LANumberUpdate,String LANumber,String LANumberPrevious)
  {
  list<Account> A=[SELECT id,Unique_Name__c,Name,keyword__c,BillingCity,BillingStreet,billingstate,BillingPostalCode,ShippingCity,ShippingStreet,shippingstate,ShippingPostalCode,Relocation_Street_1__c,Relocation_Street_2__c,Relocation_Street_3__c,Relocation_Postal_Code__c,Relocation_Region__c,Relocation_City__c,Relocation_Country__c,Approval_Status__c,
  No_NPWP__c,Segmentation_Formula__c,Customer_type__c,BP_Number__c,term_of_payment__c,term_of_payment_temp__c,Customer_VAT_Name__c,Customer_VAT_Name_2__c FROM Account WHERE ID=:AccountID];
   
      if(A.size()>0)
      {
      //Account A=[Select Name from Account WHERE ID=:C[0].accountid];
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036 AccountAddress=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036();
      AccountAddress.Task='U';
       AccountAddress.AddressType='G';
         String Name40='';
       String UniqueName40='';
       
       if(A[0].Name.length()>40)
       Name40=A[0].Name.Substring(0,40);
       else
       Name40=A[0].Name;
       if(A[0].Unique_Name__c!=null)
       {
        if(A[0].Unique_Name__c.length()>40)
       UniqueName40=A[0].Unique_Name__c.Substring(0,40);
       else
       UniqueName40=A[0].Unique_Name__c;
       }
        AccountAddress.CustomerName1=Name40;//'GEN name 1';
       AccountAddress.CustomerName2=UniqueName40;
       AccountAddress.CustomerName4='';//'GEN name 4';
       AccountAddress.SearchTerm1=A[0].keyword__c;//'GEN name';   Decimal LengthBillingStreet=A[0].billingStreet.length();
    
   list<String> Street=new list<String>();
          Street=AddressConvert(A[0].BillingStreet,60,40,40);
          AccountAddress.Street1=Street[0];
          AccountAddress.Street2=Street[1];
           AccountAddress.Street3=Street[2];
       AccountAddress.City=A[0].BillingCity;//'Jakarta';
       AccountAddress.HouseNo='';//'88';
       AccountAddress.Region='';//A[0].billingstate;//'10';
       AccountAddress.PostalCode='';//A[0].BillingPostalCode;//'15144';
       AccountAddress.Country='ID';//'ID';
       sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036 AccountAddress2=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036();
            AccountAddress2.Task='U';
       AccountAddress2.AddressType='Z';
    AccountAddress2.CustomerName1=A[0].Customer_VAT_Name__c;//'GEN name 1';
       AccountAddress2.CustomerName2=A[0].Customer_Vat_Name_2__c;//A[0].Unique_Name__c;
     AccountAddress2.CustomerName3='';//'GEN name 3';
       AccountAddress2.CustomerName4='';//'GEN name 4';
       AccountAddress2.SearchTerm1=A[0].keyword__c;//'GEN name';
        if(A[0].ShippingStreet!=null)
        { 
      
          Street=AddressConvert(A[0].ShippingStreet,60,40,40);
          AccountAddress2.Street1=Street[0];
          AccountAddress2.Street2=Street[1];
           AccountAddress2.Street3=Street[2];
        }
       AccountAddress2.City=A[0].ShippingCity;//'Jakarta';
       AccountAddress2.HouseNo='';//'88';
       AccountAddress2.Region='';//A[0].shippingstate;//'10';
       AccountAddress2.PostalCode='';//A[0].ShippingPostalCode;//'15144';
       AccountAddress2.Country='ID';//'ID';  
      list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036> listAccountAddress=new list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036>();
      listAccountAddress.add(AccountAddress);
       if(A[0].ShippingStreet!=null)
      listAccountAddress.add(AccountAddress2);
      if(A[0].relocation_street_1__c!=null)
      {
           sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036 AccountAddress3=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00036();
            AccountAddress3.Task='U';
            AccountAddress3.AddressType='Y';
            AccountAddress3.CustomerName1=A[0].Name;
            AccountAddress3.CustomerName2='';//A[0].Unique_Name__c;
            AccountAddress3.CustomerName3='';
            AccountAddress3.CustomerName4='';
             
          Street=AddressConvert(A[0].Relocation_Street_1__c,60,40,40);
          AccountAddress3.Street1=Street[0];
          AccountAddress3.Street2=Street[1];
           AccountAddress3.Street3=Street[2];
       AccountAddress3.City=A[0].relocation_City__c;
       AccountAddress3.Region='';//A[0].Relocation_Region__c;
       AccountAddress3.PostalCode='';//A[0].Relocation_Postal_Code__c;
       AccountAddress3.HouseNo='';
       AccountAddress3.Country='ID';
       listAccountAddress.add(AccountAddress3);
      }
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00035 Account=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00035();
      Transaction__c settings = Transaction__c.getOrgDefaults();
    
      Account.Task='U';
      Account.CustomerId='0000'+A[0].BP_Number__c;
      String TransactionDay=String.valueof(system.today().day());
      if(TransactionDay.length()==1)
       TransactionDay='0'+TransactionDay;
      String TransactionMonth=String.valueof(system.today().month());
       if(TransactionMonth.length()==1)
       TransactionMonth='0'+TransactionMonth;
      String TransactionDate=String.valueof(system.today().year())+transactionmonth+transactionday;
      Account.TransactionDate=TransactionDate;
     
         Account.TransactionId=String.valueof(settings.transactionID__c);//'01234567';
        settings.transactionID__c= settings.transactionID__c+1;
     

        Account.VatNo=A[0].No_NPWP__c;//'6655778899';
       Account.CustomerClass='';
      Account.CustomerType=A[0].Customer_type__c;
      if(A[0].term_of_payment__c!=null && A[0].Approval_Status__c=='Approved')
      Account.RESV1=A[0].term_of_payment__c.substring(0,4);
         list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037> listContact=new list<sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037>();

   /*   else
      Account.RESV1=A[0].term_of_payment_temp__c.substring(0,4);
      if(LANumberUpdate=true && LANumber!='' && LANumber!=null)
      {
       if(LANumberPrevious!='' && LANumberPrevious!=null)
       {sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037 ContactPrevious=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037();
       ContactPrevious.Task='D';
       ContactPrevious.LastName=LaNumberPrevious;
       ContactPrevious.Department='0015';
       ContactPrevious.Firstname='';
       ContactPrevious.Function='';
       ContactPrevious.Email='';
       ContactPrevious.Telephone='';
       ContactPrevious.Handphone='';
       listContact.add(ContactPrevious);
       }
       sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037 Contact=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdst00037();
        Contact.Task='I';
       Contact.LastName=LaNumber;
       Contact.Department='0015';
       Contact.Firstname='';
       Contact.Function='';
       Contact.Email='';
       Contact.Telephone='';
       Contact.Handphone='';
        listContact.add(Contact);
      }
       //  listContact.add(Contact);
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00037 PackageContact=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00037();
      PackageContact.item=listContact;
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00036 PackageAddress=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00036();
      PackageAddress.item=listAccountAddress;
      sapComDocumentSapSoapFunctionsMCS2.ZBD_SF_CUSTOMER_MASTER Master=new sapComDocumentSapSoapFunctionsMCS2.ZBD_SF_CUSTOMER_MASTER();
      sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00038 result=new sapComDocumentSapSoapFunctionsMCS2.Zcrmsdtt00038();
   
      //  Master.clientCert_x='MIIFVzCCBD+gAwIBAgIQBaSeWyou+UIIoQL7ph10ZTANBgkqhkiG9w0BAQsFADBwMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMS8wLQYDVQQDEyZEaWdpQ2VydCBTSEEyIEhpZ2ggQXNzdXJhbmNlIFNlcnZlciBDQTAeFw0xNjA2MDYwMDAwMDBaFw0xODA2MTExMjAwMDBaMGsxCzAJBgNVBAYTAklEMRQwEgYDVQQIEwtES0kgSmFrYXJ0YTEQMA4GA1UEBxMHSmFrYXJ0YTESMBAGA1UEChMJWEwgQXhpYXRhMSAwHgYDVQQDExdlLXN1cHBsaWVybWdtdC54bC5jby5pZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPzaXIW+lLNcOyiVlVlPZg5ZUqFbOPbSq7Yv3smdsmUVM+Nt1NpBQKErbs0ZVQbhJOvCT+HCUsmJtC5dQBJFy6c00OaSuRS87ggsLGy9ZIztG53cHdysZBi8wXg1oXZFHHRJxp3u56lJWZa3jCV9pGdso7u07S3v2euRVJ+jMfNLS31PnnBYMcAXDXRNzw8h20K5g68RwXJG4InDweKd5pq2nV/PyvcLGTSDISV/otD4Ai0QL3S/iq4OVzKklnWE0V1ujWmrrcBeLmkUCtRbuKbGaESxJ0FJg3zhuZjUm5MBJWpsfBN5HKqaklrQGfEAQOHyDmJCEhHFqWIv4cO+XTMCAwEAAaOCAfAwggHsMB8GA1UdIwQYMBaAFFFo/5CvAgd1PMzZZWRiohK4WXI7MB0GA1UdDgQWBBSjBIKr3K1x8Z96UJVQHd0VoZ6eLjAiBgNVHREEGzAZghdlLXN1cHBsaWVybWdtdC54bC5jby5pZDAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMHUGA1UdHwRuMGwwNKAyoDCGLmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9zaGEyLWhhLXNlcnZlci1nNS5jcmwwNKAyoDCGLmh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWhhLXNlcnZlci1nNS5jcmwwTAYDVR0gBEUwQzA3BglghkgBhv1sAQEwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAIBgZngQwBAgIwgYMGCCsGAQUFBwEBBHcwdTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tME0GCCsGAQUFBzAChkFodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRTSEEySGlnaEFzc3VyYW5jZVNlcnZlckNBLmNydDAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBCwUAA4IBAQBQbp1pGM9T4EGEwGqqHMYFX+a2+TUTzcAj98zyVnyeUliSD1FHl/Zadtpkl9O8NL7ZIiVOvuk33UL1Y+DZtqQBqqOJWTCbB5ZXl6/C1Ag8EVQ6lQAGevMb6RUffCUVmBZ9J4tk4pg2yCTgvp9kiuH8PzyVavupQ/WRvAV2lodtxOydzj3+wPE8J+w6p8sbNnczMcRVzc0GB3j5Ix13tDFwlK73Bdcc4pDbjW3qB1FeGE760X6PybTrOrmuvGxkIVpm0S4WGZoy0elM0bMKqSkwjfCj8Hp8njIaJPqJULvGVdcHFCPJMDPIeWpQhgGy8hk89Jv2HviNTV/NRb3IJvTX';
      //  Master.clientCert_x='MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQD82lyFvpSzXDsolZVZT2YOWVKhWzj20qu2L97JnbJlFTPjbdTaQUChK27NGVUG4STrwk/hwlLJibQuXUASRcunNNDmkrkUvO4ILCxsvWSM7Rud3B3crGQYvMF4NaF2RRx0Scad7uepSVmWt4wlfaRnbKO7tO0t79nrkVSfozHzS0t9T55wWDHAFw10Tc8PIdtCuYOvEcFyRuCJw8Hineaatp1fz8r3Cxk0gyElf6LQ+AItEC90v4quDlcypJZ1hNFdbo1pq63AXi5pFArUW7imxmhEsSdBSYN84bmY1JuTASVqbHwTeRyqmpJa0BnxAEDh8g5iQhIRxaliL+HDvl0zAgMBAAECggEAWJtUzPGKPohVmtVAbvmp8+FNWYoUHjqZPdDsq459k3qookw8yPcQ5OnJfEoiR7TiMVP4lk54oHOHFrBK4Zxfz4psokBMZ34FlAuWzcxYziHCbK3LDulIB4VVkDFAiMZ445u8a1ktSglIvHTRNgQosWpYv/2FaD1pt1Y4FBaEr1ft9kEG3y9ywGD6woK6E7U3E8ZKSljWzw5TLtuRF1iKWsgJiqet9lwVTuyhzbc8MVuN2qJuizGuyzqmDerl1yH1ODTTsv3NwmHny94AmFYa6yDrh1CYACrB+IyPaZIBaBh6KSKgWLpSsIq3V5R7MsJgNUSpnpAz0mvYMbbrS9UEQKBgQD9p9hLd3Q4WH+S8SzJH51Ree4cxKrjIYFgJNscjxyXWTMFa2ea18A3Ddb34kLYC71y5AO1YLg8Ol74VfpFlJpuCaS3yL+LIpfEfowbmBPTdceHemlX6CM7kF97mas9A18zdFvi+2cxKBNZAyDd8MRsUiuVqzkWuU2pVvwwXhcJQKBgQD/MJ4Milkomn8Iw1A4RWszDHTuH/ILAfet0X5tSCOgBHtCsFAlNx9z961BmOtfkEElzccbp+uQFeBlsYu8vAE2HYbYXnHhDv4SWPYluxtqoQt5645ztfmLNMpYP4ZTQZpghj1so5Mjiej+8bZgG9yaq4nsopdN7x5ZySGnFQLodwKBgDzqoURGdM/PWRv19ZZ7lDFsAeZAyPVxJ3vqfgCW0fv6/QjRKXmDVPMjzLuNSBZQg3fjEIzvpG86aXJkW5ExoisngYQGOIYoNjbsv1QAPfrtq7rc3i7MD2epFGtk5J2motKVLzYFudPLWOAdJfAww9Us6VKNGEpjFecQwUrJe9lNAoGBAOY3Au5HRSXXMvFB2jXZklsMStSj5yS9Eqcxjj+iS9lJEbXY/4SDVRG2iAvcm8Krjco/+PbfJyjmQ3kakfijFuit/H9nvI6PivAcZ3skcBhizsqfkfSbX1ORPVYdgN3NGisoD3PZoZz3BkYw4xmTKRIz3IqpJ5x8MsJHK9/imawDAoGBAKl3xkefFrlawauDrymhkfFw23WuCxsyzCFgefIGfajkp9qLyAsFhmPYPEfeSzmGnDdOAeKXxUWrv3VWJaWoKulJcU9vnvyF4/xcSVvopb51ZgCvKfj6bW7sT2ntKXfbIm/Y8Jkj9/ls6XUWPXZf8j6JDfBrA02ec8HaCkkDiJ/p';           
//  String PK=EncodingUtil.base64Encode('舰Ўआ蘪虈෷܁ꀂංヵං˱ā1ରआ蘪虈෷܁ꀁංベւし҂ꀿȃȁဂꐅ实⸪䋹ꄈﬂᶦ整രआ蘪虈෷āԋ　ㅰ》؉唃؄ȓ单ᔱጰ̆ѕጊ䐌杩䍩牥⁴湉ㅣ〙ؗ唃଄ဓ睷⹷楤楧散瑲挮浯⼱ⴰ̆ѕጃ䐦杩䍩牥⁴䡓㉁䠠杩⁨獁畳慲据⁥敓癲牥䌠ぁ᜞ㄍ〶〶〶〰〰娰ഗ㠱㘰ㄱ㈱〰〰ずㅫ》؉唃؄ȓ䑉ᐱሰ̆ѕገ䐋䥋䨠歡牡慴ေะ̆ѕጇ䨇歡牡慴ሱူ̆ѕጊ堉⁌硁慩慴‱Ḱ̆ѕጃ攗猭灵汰敩浲浧⹴汸挮⹯摩舰∁രआ蘪虈෷āԁ̀Ƃ舰ਁ舂āﰀ峚뺅뎔㭜锨妕晏夎ꅒ㡛틶뚫?鷉斲㌕淣?䁁⮡쵮唙係싡쥒뒉崮ቀ쭅㒧릒바࣮Ⱜ뵬豤ᯭ??撬반磁ꄵ䕶琜왉ꧧ奉랖▌ꑽ汧뮣咑ꎟ䭋佽炞ㅘៀ琍콍ℏ䋛莹ᆯ狁쎉뚚徝쫏௷㐙Ↄ缥킢˸ိ琯調ຮ㉗隤葵巑赮ꭩ삭⹞ᑩ퐊롛욦䑨➱䥁粃맡풘鎛━汪፼ᱹ骪媒᧐ñ໲䉢ᄒ꧅⽢쏡嶾ȳăĀ芣舰ἰ̆ᵕУ〘耖儔ｨ꾐܂㱵?摥ꉢ렒牙〻؝唃ฝᘄᐄңꮂ규窟镐ᵐᗝ麡⺞∰̆ᵕБ〛舙攗猭灵汰敩浲浧⹴汸挮⹯摩ะ̆ᵕď！Єȃꀅᴰ̆ᵕХ〖ؔ⬈Ćԅ̇؁⬈Ćԅ̇。ٵ唃Ἕ渄氰㐰㊠゠⺆瑨灴⼺振汲⸳楤楧散瑲挮浯猯慨ⴲ慨猭牥敶⵲㕧挮汲㐰㊠゠⺆瑨灴⼺振汲⸴楤楧散瑲挮浯猯慨ⴲ慨猭牥敶⵲㕧挮汲䰰̆ᵕРぅぃط怉䢆蘁泽ā⨰⠰ࠆثԁ܅Ăᰖ瑨灴㩳⼯睷⹷楤楧散瑲挮浯䌯卐࠰؆腧ČȂ脰ڃ⬈ĆԅćЁぷふؤ⬈Ćԅ〇蘁栘瑴㩰⼯捯灳搮杩捩牥⹴潣ねٍ⬈Ćԅ〇蘂桁瑴㩰⼯慣散瑲⹳楤楧散瑲挮浯䐯杩䍩牥却䅈䠲杩䅨獳牵湡散敓癲牥䅃挮瑲ర̆ᵕē！Ȅ0രआ蘪虈෷āԋ̀Ƃ湐榝켘葁櫀Ც׆禮ጵ샍籖办鉘儏靇嫶?靤볓븴⋙严?뛙Ƥꎪ妉鬰阇靗슯ࣔᄼ㩔稆᯳ᗩ簟ᔥᚘ❽撋飢젶龾詤ﳡ㰿檕ꧻ벑瘅螖쑭鷬㷎샾㳱Ꜻᯋ眶ㄳ嗄췍܆兩ᴣ둷瀱꺔׷᳗郢跛儇ᡞ祈绑즏뤺벮摬娡텦ᘮ騙턲䳩돑ꤊ〩籺㊞␚觺뭐嗆ߗ⌔ド젳橹虐눁᧲䶍쵟뵅⛈ퟴ舰씃舰괂ΠĂȂȐ岬樦䀋辛礋껲╆ぷ؍⨉䢆čԁ氰଱र̆ѕጆ唂ㅓ〕ؓ唃਄ఓ楄楧敃瑲䤠据ᤱᜰ̆ѕጋ眐睷搮杩捩牥⹴潣ㅭ〫ة唃̄∓楄楧敃瑲䠠杩⁨獁畳慲据⁥噅删潯⁴䅃Ḱഗ㘰ㄱ〱〰〰〰᝚㌍ㄱㄱ〰〰〰娰氰଱र̆ѕጆ唂ㅓ〕ؓ唃਄ఓ楄楧敃瑲䤠据ᤱᜰ̆ѕጋ眐睷搮杩捩牥⹴潣ㅭ〫ة唃̄∓楄楧敃瑲䠠杩⁨獁畳慲据⁥噅删潯⁴䅃舰∁രआ蘪虈෷āԁ̀Ƃ舰ਁ舂ā였퓻ⴭ꘲㾁췉䤥熶쌪铕朴ઢ뀜楟䂦쒱늷킏꒘䆩㩙?횔?㡴䪤䷌舥䫷厥㠒浉酱捾ꮶ徦꓃扏빑엸?鈸ۣࣥ಑⣄啁쯻襚縕뼵牍㴉㪾倸睛ᬱ뎍Ⓡ驅겧m娔뜄Ꮊ凫頊䅁丢慥膇偁禦襜᧞坊⻕左匜縬춘ؚꐖ獨㓐ጄꅜ퍱籚?摞㟡ょіᇥ⦴ኀ秱蠹ʢ簑昧袷碷쫲ꠊꬸ搊뿂嵦蒕ꇁḥ嶇倚​찒뭁୮㡑䮸ˋăĀ掣愰ะ̆ᵕď！Єȃ蘁༰̆ᵕē！Ԅ̰āヿ؝唃ฝᘄᐄ㺱槃䞿퐁⚘ࠚ摣쌫ἰ̆ᵕУ〘耖넔쌾ͩ뿸Ň飔ᨦȈ揯⭤ッ؍⨉䢆čԁ舃āᰀؚ?鳗㲟暈ࠆ⅗⇛未뾪㈘䁶圐諁竳ᇙ蹥卑ﲞ땅?ㅌ롋ⱃ뎎칸祓홱⇥Ɣ嗚骇搤諶챦鳞촷㒨榱⎛黈≸瀫䝕愱았⾅ぎꃶᘱ젣ᙥ쬳ᪿꀛ廊ㆋ悋褈భ将띒龍頊ᗑ齟븒㙼㡣䒽群⛤ਫ韄൩賩샢圐좸ቶ喑䣲?⪼嬂䐏⃔?뫴♰遝鹠䮼ग됯ị桃߉섧峒뤡ቨ㲜뾜ﲞ岀掛ꩇ✥ꁧ舀命꧗ጮ瞣Ῠお҂ケ΂ꂙȃȁဂꓧ峜쁭䈫嶸鼕രआ蘪虈෷āԋ　ㅬ》؉唃؄ȓ单ᔱጰ̆ѕጊ䐌杩䍩牥⁴湉ㅣ〙ؗ唃଄ဓ睷⹷楤楧散瑲挮浯⬱⤰̆ѕጃ䐢杩䍩牥⁴楈桧䄠獳牵湡散䔠⁖潒瑯䌠ぁ᜞ㄍㄳ㈰ㄲ〲〰娰ഗ㠲〱㈲㈱〰〰ずㅰ》؉唃؄ȓ单ᔱጰ̆ѕጊ䐌杩䍩牥⁴湉ㅣ〙ؗ唃଄ဓ睷⹷楤楧散瑲挮浯⼱ⴰ̆ѕጃ䐦杩䍩牥⁴䡓㉁䠠杩⁨獁畳慲据⁥敓癲牥䌠ぁƂ〢؍⨉䢆čā舃༁　ƂȊƂ숯ؤ淈弄搊눆≽攦긖䁂캛鿜皟㸇ッ蝕뤙鑏娎ᾔ噕슴⨂킯䀋쓗㯐졲鸔郯ᆱ꺩죒䎸?ଋ헕꽀᷈䷭徜띗傆饨諵틚ׇꠟ즗ꓜ花ⶄ귆鲥ᧇꚂ྅䑞⩘輷㗽௱✈娲믵麋붤큑㯝㍂֣쐨⢻髌⮬ണ외煞䪷࠾臻ᚷꄖ⎝䴒ퟥ࢒疬鲤춺눗䐞攵卿㤥᳑騊᭣鈙桴㜊싂䡒㧋ꉚ셝ꃝ렠ꈡ⚓ᑯ⅊읁淭⽈ϳꋵ鉨⽓̂ꌁƂぉƂぅؒ唃ጝāӿ〈Ć！Ă　؎唃༝āӿ̄Ăゆ؝唃┝ᘄᐰࠆثԁ܅ăࠆثԁ܅ȃ㐰ࠆثԁ܅ā⠄☰␰ࠆثԁ܅İᢆ瑨灴⼺漯獣⹰楤楧散瑲挮浯䬰̆ᵕПいあꁀꀾ蘼栺瑴㩰⼯牣㑬搮杩捩牥⹴潣⽭楄楧敃瑲楈桧獁畳慲据䕥剖潯䍴⹁牣ぬؽ唃”㘄㐰㈰Іᵕ ⨰⠰ࠆثԁ܅Ăᰖ瑨灴㩳⼯睷⹷楤楧散瑲挮浯䌯卐ᴰ̆ᵕЎЖ儔ｨ꾐܂㱵?摥ꉢ렒牙〻؟唃⌝᠄ᘰᒀ㺱槃䞿퐁⚘ࠚ摣쌫രआ蘪虈෷āԋ̀Ƃ記覕?ﱜ栝䫪莏凖贯䑫鸖掬틵汮馄ꪋ熁宄㓭끎禷⦒ⷌ檀軰ꑹϾፇ쪆煙阄퍫塙︽㇓尥㠘ꎄ鿦ﶂ完㆘쵎鹸ﴚ쮅ꩉ⟲馋ﱲ꨾䇕?㛕뾡渜䥇广䣙ͼ﷙䦋颠䈦鋖ꐑ੤呗혝市걫쓮骀爒固힓뿿蔰〆ி乿埿鴅쎅שׂ疦겨ᘭ緯❹鷂܋ꫪ펅ꌁ⠠奁⡃臒ꫣ㭻뙷所ր䕁ؗ?㏀枛懓爮ﱩ䁗瀞ỵ듉1');
  //  Master.clientCert_x=PK; 
  //      Master.clientCertPasswd_x='S4Padmin';
  Master.inputHttpHeaders_x=new Map<String,String>();

           String username = system.label.SAPUsername;//'xlsapint';
          String password = apputils.doDecrypt(system.label.SAPPassword);//'jakarta03';
Blob headerValue = Blob.valueOf(username + ':' + password);
String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
Master.inputHttpHeaders_x.put('Authorization',authorizationHeader);
Master.inputHttpHeaders_x.put('Content-Type', 'text/xml');

      try
      {
      result=Master.ZsfCustomerMaster(PackageAddress,PackageContact,Account);
     list<sapComDocumentSapSoapFunctionsMCS2.Zexdsdst00097> msg=new list<sapComDocumentSapSoapFunctionsMCS2.Zexdsdst00097>();
      sapComDocumentSapSoapFunctionsMcS2.Zexdsdtt00052 rslt=new sapComDocumentSapSoapFunctionsMcS2.Zexdsdtt00052();
      list<sapComDocumentSapSoapFunctionsMcS2.Zcrmsdst00038> listitem=new list<sapComDocumentSapSoapFunctionsMcS2.Zcrmsdst00038>();
      system.debug(result);
      listitem=result.Item;
      rslt=listitem[0].Messages;
      msg=rslt.item;
     
      Call_Log__c CL=new Call_Log__c();
      CL.endpoint__c=Master.endpoint_x;
        CL.Request_Message__c=String.valueof('  Contact'+PackageContact+'  AccountAddress'+PackageAddress+'   Account'+Account);
     
        CL.response_message__c=String.valueof(msg[0]);
   
      CL.response_end_time__c=system.now();
      CL.Type__c='Callout';
      insert CL;
       update settings;
      }
       catch(exception e)
      {
           Call_Log__c CL=new Call_Log__c();
      CL.endpoint__c=Master.endpoint_x;
 //    system.debug(msg[0]);
        CL.response_message__c='MESSAGE:' +e.getmessage()+' StacktraceString:  '+e.getstacktraceString()+'  Cause  :'+e.getcause();
        CL.Request_Message__c=String.valueof('  Contact'+PackageContact+'  AccountAddress'+PackageAddress+'   Account'+Account);
   // CL.Method__c='SAP';
      CL.response_end_time__c=system.now();
      CL.Type__c='Callout';
      insert CL;
       update settings;
      }
      }
  }
*/
  @future(callout=true) 
  public static void UpdateAccount2(String AccountID,Boolean LANumberUpdate,String LANumber,String LANumberPrevious)
  {
      Datetime startTime = system.now();
      String status = '';
      String errMessage = '';     
      
      //map variable to parameter SAP
      list<Account> AccountObj=[SELECT id,Unique_Name__c,Name,keyword__c,BillingCity,BillingStreet,billingstate,BillingPostalCode,ShippingCity,ShippingStreet,shippingstate,ShippingPostalCode,Relocation_Street_1__c,Relocation_Street_2__c,Relocation_Street_3__c,Relocation_Postal_Code__c,Relocation_Region__c,Relocation_City__c,Relocation_Country__c,Approval_Status__c,
                       No_NPWP__c,Segmentation_Formula__c,Customer_type__c,BP_Number__c,term_of_payment__c,term_of_payment_temp__c,Customer_VAT_Name__c,Customer_VAT_Name_2__c,Customer_VAT_Name_3__c, Customer_VAT_Name_4__c FROM Account WHERE ID=:AccountID];
      
      if(AccountObj.size()>0)
      {
          //Account A=[Select Name from Account WHERE ID=:C[0].accountid];
          sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00036 AccountAddress=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00036();
          AccountAddress.Task='U';
          AccountAddress.AddressType='G';
          String Name40='';
          String UniqueName40='';
          
          if(AccountObj[0].Name.length()>40)
              Name40=AccountObj[0].Name.Substring(0,40);
          else
              Name40=AccountObj[0].Name;
          if(AccountObj[0].Unique_Name__c!=null)
          {
              if(AccountObj[0].Unique_Name__c.length()>40)
                  UniqueName40=AccountObj[0].Unique_Name__c.Substring(0,40);
              else
                  UniqueName40=AccountObj[0].Unique_Name__c;
          }
          AccountAddress.CustomerName1=Name40;//'GEN name 1';
          AccountAddress.CustomerName2=UniqueName40;
          AccountAddress.CustomerName4='';//'GEN name 4';
          AccountAddress.SearchTerm1=AccountObj[0].keyword__c;//'GEN name';   Decimal LengthBillingStreet=A[0].billingStreet.length();
          
          list<String> Street=new list<String>();
          Street=AddressConvert(AccountObj[0].BillingStreet,60,40,40);
          AccountAddress.Street1=Street[0];
          AccountAddress.Street2=Street[1];
          AccountAddress.Street3=Street[2];
          AccountAddress.City=AccountObj[0].BillingCity;//'Jakarta';
          AccountAddress.HouseNo='';//'88';
          AccountAddress.Region='';//A[0].billingstate;//'10';
          AccountAddress.PostalCode='';//A[0].BillingPostalCode;//'15144';
          AccountAddress.Country='ID';//'ID';
          sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00036 AccountAddress2=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00036();
          AccountAddress2.Task='U';
          AccountAddress2.AddressType='Z';
          AccountAddress2.CustomerName1=AccountObj[0].Customer_VAT_Name__c;//'GEN name 1';
          AccountAddress2.CustomerName2=AccountObj[0].Customer_Vat_Name_2__c;//A[0].Unique_Name__c;
          AccountAddress2.CustomerName3=AccountObj[0].Customer_Vat_Name_3__c;
          AccountAddress2.CustomerName4=AccountObj[0].Customer_Vat_Name_4__c;
          AccountAddress2.SearchTerm1=AccountObj[0].keyword__c;//'GEN name';
          if(AccountObj[0].ShippingStreet!=null)
          { 
              
              Street=AddressConvert(AccountObj[0].ShippingStreet,60,40,40);
              AccountAddress2.Street1=Street[0];
              AccountAddress2.Street2=Street[1];
              AccountAddress2.Street3=Street[2];
          }
          AccountAddress2.City=AccountObj[0].ShippingCity;//'Jakarta';
          AccountAddress2.HouseNo='';//'88';
          AccountAddress2.Region='';//A[0].shippingstate;//'10';
          AccountAddress2.PostalCode='';//A[0].ShippingPostalCode;//'15144';
          AccountAddress2.Country='ID';//'ID';  
          list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00036> listAccountAddress=new list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00036>();
          listAccountAddress.add(AccountAddress);
          if(AccountObj[0].ShippingStreet!=null)
              listAccountAddress.add(AccountAddress2);
          if(AccountObj[0].relocation_street_1__c!=null)
          {
              sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00036 AccountAddress3=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00036();
              AccountAddress3.Task='U';
              AccountAddress3.AddressType='Y';
              AccountAddress3.CustomerName1=AccountObj[0].Name;
              AccountAddress3.CustomerName2='';//A[0].Unique_Name__c;
              AccountAddress3.CustomerName3='';
              AccountAddress3.CustomerName4='';
              
              Street=AddressConvert(AccountObj[0].Relocation_Street_1__c,60,40,40);
              AccountAddress3.Street1=Street[0];
              AccountAddress3.Street2=Street[1];
              AccountAddress3.Street3=Street[2];
              AccountAddress3.City=AccountObj[0].relocation_City__c;
              AccountAddress3.Region='';//A[0].Relocation_Region__c;
              AccountAddress3.PostalCode='';//A[0].Relocation_Postal_Code__c;
              AccountAddress3.HouseNo='';
              AccountAddress3.Country='ID';
              listAccountAddress.add(AccountAddress3);
          }
          sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00035 Account=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00035();
          Transaction__c settings = Transaction__c.getOrgDefaults();
          
          Account.Task='U';
          Account.CustomerId='0000'+AccountObj[0].BP_Number__c;
          String TransactionDay=String.valueof(system.today().day());
          if(TransactionDay.length()==1)
              TransactionDay='0'+TransactionDay;
          String TransactionMonth=String.valueof(system.today().month());
          if(TransactionMonth.length()==1)
              TransactionMonth='0'+TransactionMonth;
          String TransactionDate=String.valueof(system.today().year())+transactionmonth+transactionday;
          Account.TransactionDate=TransactionDate;
          
          Account.TransactionId=String.valueof(settings.transactionID__c);//'01234567';
          settings.transactionID__c= settings.transactionID__c+1;
          
          
          Account.VatNo=AccountObj[0].No_NPWP__c;//'6655778899';
          Account.CustomerClass='';
          Account.CustomerType=AccountObj[0].Customer_type__c;
          if(AccountObj[0].term_of_payment__c!=null && AccountObj[0].Approval_Status__c=='Approved')
              Account.RESV1=AccountObj[0].term_of_payment__c.substring(0,4);
          list<sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00037> listContact=new list<sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00037>();
          
          /*   else
Account.RESV1=A[0].term_of_payment_temp__c.substring(0,4);*/
          if(LANumberUpdate=true && LANumber!='' && LANumber!=null)
          {
            /* ---- Fungsi ini sementara dimatikan karena ada error di SAP (tidak bisa delete)
                    request date    : 26 November 2020
                    request by      : Kahfi.
                    developer       : doddy

            if(LANumberPrevious!='' && LANumberPrevious!=null)
              {sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00037 ContactPrevious=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00037();
               ContactPrevious.Task='D';
               ContactPrevious.LastName=LaNumberPrevious;
               ContactPrevious.Department='0015';
               ContactPrevious.Firstname='';
               ContactPrevious.Function='';
               ContactPrevious.Email='';
               ContactPrevious.Telephone='';
               ContactPrevious.Handphone='';
               ContactPrevious.ContactId = LaNumberPrevious;     //-- tambahan per 12 Nov 2020 by doddy : untuk identifier unique ID
               listContact.add(ContactPrevious);
              }
            */

              sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00037 Contact=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdst00037();
              Contact.Task='I';
              Contact.LastName=LaNumber;
              Contact.Department='0015';
              Contact.Firstname='';
              Contact.Function='';
              Contact.Email='';
              Contact.Telephone='';
              Contact.Handphone='';
              Contact.ContactId = LaNumber;     //-- tambahan per 12 Nov 2020 by doddy : untuk identifier unique ID
              listContact.add(Contact);
          }
          //  listContact.add(Contact);
          sapComDocumentSapSoapFunctionsMCShana.Zcrmsdtt00037 PackageContact=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdtt00037();
          PackageContact.item=listContact;
          sapComDocumentSapSoapFunctionsMCShana.Zcrmsdtt00036 PackageAddress=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdtt00036();
          PackageAddress.item=listAccountAddress;
          sapComDocumentSapSoapFunctionsMCShana.ZBD_SF_CUSTOMER_MASTER Master=new sapComDocumentSapSoapFunctionsMCShana.ZBD_SF_CUSTOMER_MASTER();
          sapComDocumentSapSoapFunctionsMCShana.Zcrmsdtt00038 result=new sapComDocumentSapSoapFunctionsMCShana.Zcrmsdtt00038();
          
          //prepare to hit to SAP
          Master.inputHttpHeaders_x=new Map<String,String>();
          Master.timeout_x = 120000; //-- set timeout to 2 minutes (December 13, 2021 by doddy)
          
          String username =system.label.SAPUsername;//'xlsapint';//'P2001211266';
          String password = apputils.doDecrypt(system.label.SAPPassword);//'jakarta03';//'M@nt4pXL';
          Blob headerValue = Blob.valueOf(username + ':' + password);
          String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
          Master.inputHttpHeaders_x.put('Authorization',authorizationHeader);
          Master.inputHttpHeaders_x.put('Content-Type', 'text/xml');
          
          try
          {
              result=Master.ZsfCustomerMaster(PackageAddress,PackageContact,Account);
              list<sapComDocumentSapSoapFunctionsMCShana.Zexdsdst00097> msg=new list<sapComDocumentSapSoapFunctionsMCShana.Zexdsdst00097>();
              sapComDocumentSapSoapFunctionsMcShana.Zexdsdtt00052 rslt=new sapComDocumentSapSoapFunctionsMcShana.Zexdsdtt00052();
              list<sapComDocumentSapSoapFunctionsMcShana.Zcrmsdst00038> listitem=new list<sapComDocumentSapSoapFunctionsMcShana.Zcrmsdst00038>();
              system.debug(result);
              listitem=result.Item;
              rslt=listitem[0].Messages;
              msg=rslt.item;

              if(listitem[0].IsError=='')
                  status = 'Success';
              else if(listitem[0].IsError=='X')
                  status = 'Failed';
              
              update settings;
              
          }
          catch(exception e)
          {
              status = 'Failed';
              errMessage =  ' :: error message : ' + e.getmessage()  
                  + ' :: StacktraceString : ' + e.getstacktraceString() 
                  + ' :: LineNumber : ' + e.getLineNumber() ;
                                      
              update settings;
          }
          
          //-- PUT CALL LOG
          Call_Log__c CL=new Call_Log__c();
          CL.Request_Start_Time__c = startTime;
          CL.CallerFrom__c  = 'Salesforce';
          CL.endpoint__c = Master.endpoint_x;
          CL.status__c = status;
          /*
          CL.Request_Message__c=String.valueof(' %% Contact : ' + JSON.serialize(PackageContact)
                                               + ' %%  AccountAddress : ' + JSON.serialize(PackageAddress)
                                               + ' %%  Account : '+ JSON.serialize(Account) );
          */
          CL.Request_Message__c=String.valueof('{ "Contact" :' + JSON.serialize(PackageContact) + ', '
                                               + ' "AccountAddress" : ' + JSON.serialize(PackageAddress)  + ', '
                                               + ' "Account" : '+ JSON.serialize(Account) + ' }'  );            
          //CL.response_message__c=String.valueof(msg[0]);
          CL.response_message__c=String.valueof(JSON.serialize(result) );
          CL.error_message__c = errMessage;
          CL.response_end_time__c=system.now();
          CL.Type__c='Callout';
          insert CL; 
   
      }
  }
  
  @future(callout=true) 
  public static void UpdateAccountChangeowner(String AccountID,String oldownerid,String newownerid)
  {
      Datetime startTime = system.now();
      String status = '';
      String errMessage = '';
      
      list<Account> AccountObjc=[SELECT id,Unique_Name__c,Name,keyword__c,BillingCity,BillingStreet,billingstate,BillingPostalCode,ShippingCity,ShippingStreet,shippingstate,ShippingPostalCode,Relocation_Street_1__c,Relocation_Street_2__c,Relocation_Street_3__c,Relocation_Postal_Code__c,Relocation_Region__c,Relocation_City__c,Relocation_Country__c,
                       No_NPWP__c,Customer_type__c,Segmentation_Formula__c,BP_Number__c,term_of_payment__c,term_of_payment_temp__c,approval_status__c, Customer_Vat_Name__c,Customer_Vat_Name_2__c,Customer_Vat_Name_3__c,Customer_Vat_Name_4__c FROM Account WHERE ID=:AccountID];
      
      list <user> U=[SELECT id,employee_id__c,firstname,lastname,email,mobilephone,phone from user WHERE Id=:oldownerid OR Id=:newownerid];
   
      if(AccountObjc.size()>0)
      {
          //Account A=[Select Name from Account WHERE ID=:C[0].accountid];
          sapComDocumentSapSoapFunctionsMCSHana.Zcrmsdst00036 AccountAddress=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00036();
          AccountAddress.Task='U';
          AccountAddress.AddressType='G';
          String Name40='';
          String UniqueName40='';
          
          if(AccountObjc[0].Name.length()>40)
              Name40=AccountObjc[0].Name.Substring(0,40);
          else
              Name40=AccountObjc[0].Name;
          if(AccountObjc[0].Unique_Name__c!=null)
          {
              if(AccountObjc[0].Unique_Name__c.length()>40)
                  UniqueName40=AccountObjc[0].Unique_Name__c.Substring(0,40);
              else
                  UniqueName40=AccountObjc[0].Unique_Name__c;
          }
          AccountAddress.CustomerName1=Name40;//'GEN name 1';
          AccountAddress.CustomerName2=UniqueName40;
          AccountAddress.CustomerName4='';//'GEN name 4';
          AccountAddress.SearchTerm1=AccountObjc[0].keyword__c;//'GEN name';   Decimal LengthBillingStreet=A[0].billingStreet.length();
          
          list<String> Street=new list<String>();
          Street=AddressConvert(AccountObjc[0].BillingStreet,60,40,40);
          AccountAddress.Street1=Street[0];
          AccountAddress.Street2=Street[1];
          AccountAddress.Street3=Street[2];
          AccountAddress.City=AccountObjc[0].BillingCity;//'Jakarta';
          AccountAddress.HouseNo='';//'88';
          AccountAddress.Region='';//A[0].billingstate;//'10';
          AccountAddress.PostalCode='';//A[0].BillingPostalCode;//'15144';
          AccountAddress.Country='ID';//'ID';
          sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00036 AccountAddress2=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00036();
          AccountAddress2.Task='U';
          AccountAddress2.AddressType='Z';
          AccountAddress2.CustomerName1=AccountObjc[0].Customer_Vat_Name__c;
          AccountAddress2.CustomerName2=AccountObjc[0].Customer_Vat_Name_2__c;
          AccountAddress2.CustomerName3=AccountObjc[0].Customer_Vat_Name_3__c;
          AccountAddress2.CustomerName4=AccountObjc[0].Customer_Vat_Name_4__c;
          AccountAddress2.SearchTerm1=AccountObjc[0].keyword__c;//'GEN name';
          if(AccountObjc[0].ShippingStreet!=null)
          { 
              
              Street=AddressConvert(AccountObjc[0].ShippingStreet,60,40,40);
              AccountAddress2.Street1=Street[0];
              AccountAddress2.Street2=Street[1];
              AccountAddress2.Street3=Street[2];
          }
          AccountAddress2.City=AccountObjc[0].ShippingCity;//'Jakarta';
          AccountAddress2.HouseNo='';//'88';
          AccountAddress2.Region='';//A[0].shippingstate;//'10';
          //     AccountAddress2.PostalCode=A[0].ShippingPostalCode;//'15144';
          AccountAddress2.Country='ID';//'ID';  
          list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00036> listAccountAddress=new list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00036>();
          listAccountAddress.add(AccountAddress);
          listAccountAddress.add(AccountAddress2);
          if(AccountObjc[0].relocation_street_1__c!=null)
          {
              sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00036 AccountAddress3=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00036();
              AccountAddress3.Task='U';
              AccountAddress3.AddressType='Y';
              AccountAddress3.CustomerName1=AccountObjc[0].Name;
              AccountAddress3.CustomerName2='';//A[0].Unique_Name__c;
              AccountAddress3.CustomerName3='';
              AccountAddress3.CustomerName4='';
              AccountAddress3.Region='';//A[0].Relocation_Region__c;
              Street=AddressConvert(AccountObjc[0].Relocation_Street_1__c,60,40,40);
              AccountAddress3.Street1=Street[0];
              AccountAddress3.Street2=Street[1];
              AccountAddress3.Street3=Street[2];
              AccountAddress3.City=AccountObjc[0].relocation_City__c;
              AccountAddress3.PostalCode='';//A[0].Relocation_Postal_Code__c;
              AccountAddress3.HouseNo='';
              AccountAddress3.Country='ID';
              listAccountAddress.add(AccountAddress3);
          }
          sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00035 Account=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00035();
          Transaction__c settings = Transaction__c.getOrgDefaults();
          
          Account.Task='P';
          Account.CustomerId='0000'+AccountObjc[0].BP_Number__c;
          String TransactionDay=String.valueof(system.today().day());
          if(TransactionDay.length()==1)
              TransactionDay='0'+TransactionDay;
          String TransactionMonth=String.valueof(system.today().month());
          if(TransactionMonth.length()==1)
              TransactionMonth='0'+TransactionMonth;
          String TransactionDate=String.valueof(system.today().year())+transactionmonth+transactionday;
          Account.TransactionDate=TransactionDate;
          
          Account.TransactionId=String.valueof(settings.transactionID__c);//'01234567';
          settings.transactionID__c= settings.transactionID__c+1;
          
          
          Account.VatNo=AccountObjc[0].No_NPWP__c;//'6655778899';
          Account.CustomerClass='';
          Account.CustomerType=AccountObjc[0].Customer_type__c;
          if(AccountObjc[0].term_of_payment__c!=null && AccountObjc[0].Approval_Status__c=='Approved')
              Account.RESV1=AccountObjc[0].term_of_payment__c.substring(0,4);
          // else
          // Account.RESV1=A[0].term_of_payment_temp__c.substring(0,4);
          list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037> listContact=new list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037>();
          for(user us:U)
          {
              sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037 Contact=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00037();
              if(us.id==oldownerid)
                  Contact.Task='D';
              if(us.id==newownerid)
                  Contact.Task='I';
              Contact.Contactid=us.employee_id__c;
              Contact.Firstname=us.firstname;
              Contact.Lastname=us.lastname;
              Contact.Function='';
              Contact.Department='0011';
              Contact.Telephone=us.phone;
              Contact.Handphone=us.mobilephone;
              Contact.Email=us.email;
              //-- update tanggal 11 Jan 2020 : Ditutup kembali menggunakan employee_id__c 
              //Contact.ContactId = us.id;     //-- tambahan per 12 Nov 2020 by doddy : untuk identifier unique ID
              if(us.employee_id__c!='' && us.employee_id__c!=null)
                  listContact.add(Contact);
          }
          
          sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00037 PackageContact=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00037();
          PackageContact.item=listContact;
          sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00036 PackageAddress=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00036();
          PackageAddress.item=listAccountAddress;
          sapComDocumentSapSoapFunctionsMcSHANA.ZBD_SF_CUSTOMER_MASTER Master=new sapComDocumentSapSoapFunctionsMcSHANA.ZBD_SF_CUSTOMER_MASTER();
          sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00038 result=new sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdtt00038();
          
          //  Master.clientCert_x='MIIFVzCCBD+gAwIBAgIQBaSeWyou+UIIoQL7ph10ZTANBgkqhkiG9w0BAQsFADBwMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMS8wLQYDVQQDEyZEaWdpQ2VydCBTSEEyIEhpZ2ggQXNzdXJhbmNlIFNlcnZlciBDQTAeFw0xNjA2MDYwMDAwMDBaFw0xODA2MTExMjAwMDBaMGsxCzAJBgNVBAYTAklEMRQwEgYDVQQIEwtES0kgSmFrYXJ0YTEQMA4GA1UEBxMHSmFrYXJ0YTESMBAGA1UEChMJWEwgQXhpYXRhMSAwHgYDVQQDExdlLXN1cHBsaWVybWdtdC54bC5jby5pZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPzaXIW+lLNcOyiVlVlPZg5ZUqFbOPbSq7Yv3smdsmUVM+Nt1NpBQKErbs0ZVQbhJOvCT+HCUsmJtC5dQBJFy6c00OaSuRS87ggsLGy9ZIztG53cHdysZBi8wXg1oXZFHHRJxp3u56lJWZa3jCV9pGdso7u07S3v2euRVJ+jMfNLS31PnnBYMcAXDXRNzw8h20K5g68RwXJG4InDweKd5pq2nV/PyvcLGTSDISV/otD4Ai0QL3S/iq4OVzKklnWE0V1ujWmrrcBeLmkUCtRbuKbGaESxJ0FJg3zhuZjUm5MBJWpsfBN5HKqaklrQGfEAQOHyDmJCEhHFqWIv4cO+XTMCAwEAAaOCAfAwggHsMB8GA1UdIwQYMBaAFFFo/5CvAgd1PMzZZWRiohK4WXI7MB0GA1UdDgQWBBSjBIKr3K1x8Z96UJVQHd0VoZ6eLjAiBgNVHREEGzAZghdlLXN1cHBsaWVybWdtdC54bC5jby5pZDAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMHUGA1UdHwRuMGwwNKAyoDCGLmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9zaGEyLWhhLXNlcnZlci1nNS5jcmwwNKAyoDCGLmh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWhhLXNlcnZlci1nNS5jcmwwTAYDVR0gBEUwQzA3BglghkgBhv1sAQEwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAIBgZngQwBAgIwgYMGCCsGAQUFBwEBBHcwdTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tME0GCCsGAQUFBzAChkFodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRTSEEySGlnaEFzc3VyYW5jZVNlcnZlckNBLmNydDAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBCwUAA4IBAQBQbp1pGM9T4EGEwGqqHMYFX+a2+TUTzcAj98zyVnyeUliSD1FHl/Zadtpkl9O8NL7ZIiVOvuk33UL1Y+DZtqQBqqOJWTCbB5ZXl6/C1Ag8EVQ6lQAGevMb6RUffCUVmBZ9J4tk4pg2yCTgvp9kiuH8PzyVavupQ/WRvAV2lodtxOydzj3+wPE8J+w6p8sbNnczMcRVzc0GB3j5Ix13tDFwlK73Bdcc4pDbjW3qB1FeGE760X6PybTrOrmuvGxkIVpm0S4WGZoy0elM0bMKqSkwjfCj8Hp8njIaJPqJULvGVdcHFCPJMDPIeWpQhgGy8hk89Jv2HviNTV/NRb3IJvTX';
          //  Master.clientCert_x='MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQD82lyFvpSzXDsolZVZT2YOWVKhWzj20qu2L97JnbJlFTPjbdTaQUChK27NGVUG4STrwk/hwlLJibQuXUASRcunNNDmkrkUvO4ILCxsvWSM7Rud3B3crGQYvMF4NaF2RRx0Scad7uepSVmWt4wlfaRnbKO7tO0t79nrkVSfozHzS0t9T55wWDHAFw10Tc8PIdtCuYOvEcFyRuCJw8Hineaatp1fz8r3Cxk0gyElf6LQ+AItEC90v4quDlcypJZ1hNFdbo1pq63AXi5pFArUW7imxmhEsSdBSYN84bmY1JuTASVqbHwTeRyqmpJa0BnxAEDh8g5iQhIRxaliL+HDvl0zAgMBAAECggEAWJtUzPGKPohVmtVAbvmp8+FNWYoUHjqZPdDsq459k3qookw8yPcQ5OnJfEoiR7TiMVP4lk54oHOHFrBK4Zxfz4psokBMZ34FlAuWzcxYziHCbK3LDulIB4VVkDFAiMZ445u8a1ktSglIvHTRNgQosWpYv/2FaD1pt1Y4FBaEr1ft9kEG3y9ywGD6woK6E7U3E8ZKSljWzw5TLtuRF1iKWsgJiqet9lwVTuyhzbc8MVuN2qJuizGuyzqmDerl1yH1ODTTsv3NwmHny94AmFYa6yDrh1CYACrB+IyPaZIBaBh6KSKgWLpSsIq3V5R7MsJgNUSpnpAz0mvYMbbrS9UEQKBgQD9p9hLd3Q4WH+S8SzJH51Ree4cxKrjIYFgJNscjxyXWTMFa2ea18A3Ddb34kLYC71y5AO1YLg8Ol74VfpFlJpuCaS3yL+LIpfEfowbmBPTdceHemlX6CM7kF97mas9A18zdFvi+2cxKBNZAyDd8MRsUiuVqzkWuU2pVvwwXhcJQKBgQD/MJ4Milkomn8Iw1A4RWszDHTuH/ILAfet0X5tSCOgBHtCsFAlNx9z961BmOtfkEElzccbp+uQFeBlsYu8vAE2HYbYXnHhDv4SWPYluxtqoQt5645ztfmLNMpYP4ZTQZpghj1so5Mjiej+8bZgG9yaq4nsopdN7x5ZySGnFQLodwKBgDzqoURGdM/PWRv19ZZ7lDFsAeZAyPVxJ3vqfgCW0fv6/QjRKXmDVPMjzLuNSBZQg3fjEIzvpG86aXJkW5ExoisngYQGOIYoNjbsv1QAPfrtq7rc3i7MD2epFGtk5J2motKVLzYFudPLWOAdJfAww9Us6VKNGEpjFecQwUrJe9lNAoGBAOY3Au5HRSXXMvFB2jXZklsMStSj5yS9Eqcxjj+iS9lJEbXY/4SDVRG2iAvcm8Krjco/+PbfJyjmQ3kakfijFuit/H9nvI6PivAcZ3skcBhizsqfkfSbX1ORPVYdgN3NGisoD3PZoZz3BkYw4xmTKRIz3IqpJ5x8MsJHK9/imawDAoGBAKl3xkefFrlawauDrymhkfFw23WuCxsyzCFgefIGfajkp9qLyAsFhmPYPEfeSzmGnDdOAeKXxUWrv3VWJaWoKulJcU9vnvyF4/xcSVvopb51ZgCvKfj6bW7sT2ntKXfbIm/Y8Jkj9/ls6XUWPXZf8j6JDfBrA02ec8HaCkkDiJ/p';           
          //  String PK=EncodingUtil.base64Encode('舰Ўआ蘪虈෷܁ꀂංヵං˱ā1ରआ蘪虈෷܁ꀁංベւし҂ꀿȃȁဂꐅ实⸪䋹ꄈﬂᶦ整രआ蘪虈෷āԋ　ㅰ》؉唃؄ȓ单ᔱጰ̆ѕጊ䐌杩䍩牥⁴湉ㅣ〙ؗ唃଄ဓ睷⹷楤楧散瑲挮浯⼱ⴰ̆ѕጃ䐦杩䍩牥⁴䡓㉁䠠杩⁨獁畳慲据⁥敓癲牥䌠ぁ᜞ㄍ〶〶〶〰〰娰ഗ㠱㘰ㄱ㈱〰〰ずㅫ》؉唃؄ȓ䑉ᐱሰ̆ѕገ䐋䥋䨠歡牡慴ေะ̆ѕጇ䨇歡牡慴ሱူ̆ѕጊ堉⁌硁慩慴‱Ḱ̆ѕጃ攗猭灵汰敩浲浧⹴汸挮⹯摩舰∁രआ蘪虈෷āԁ̀Ƃ舰ਁ舂āﰀ峚뺅뎔㭜锨妕晏夎ꅒ㡛틶뚫?鷉斲㌕淣?䁁⮡쵮唙係싡쥒뒉崮ቀ쭅㒧릒바࣮Ⱜ뵬豤ᯭ??撬반磁ꄵ䕶琜왉ꧧ奉랖▌ꑽ汧뮣咑ꎟ䭋佽炞ㅘៀ琍콍ℏ䋛莹ᆯ狁쎉뚚徝쫏௷㐙Ↄ缥킢˸ိ琯調ຮ㉗隤葵巑赮ꭩ삭⹞ᑩ퐊롛욦䑨➱䥁粃맡풘鎛━汪፼ᱹ骪媒᧐ñ໲䉢ᄒ꧅⽢쏡嶾ȳăĀ芣舰ἰ̆ᵕУ〘耖儔ｨ꾐܂㱵?摥ꉢ렒牙〻؝唃ฝᘄᐄңꮂ규窟镐ᵐᗝ麡⺞∰̆ᵕБ〛舙攗猭灵汰敩浲浧⹴汸挮⹯摩ะ̆ᵕď！Єȃꀅᴰ̆ᵕХ〖ؔ⬈Ćԅ̇؁⬈Ćԅ̇。ٵ唃Ἕ渄氰㐰㊠゠⺆瑨灴⼺振汲⸳楤楧散瑲挮浯猯慨ⴲ慨猭牥敶⵲㕧挮汲㐰㊠゠⺆瑨灴⼺振汲⸴楤楧散瑲挮浯猯慨ⴲ慨猭牥敶⵲㕧挮汲䰰̆ᵕРぅぃط怉䢆蘁泽ā⨰⠰ࠆثԁ܅Ăᰖ瑨灴㩳⼯睷⹷楤楧散瑲挮浯䌯卐࠰؆腧ČȂ脰ڃ⬈ĆԅćЁぷふؤ⬈Ćԅ〇蘁栘瑴㩰⼯捯灳搮杩捩牥⹴潣ねٍ⬈Ćԅ〇蘂桁瑴㩰⼯慣散瑲⹳楤楧散瑲挮浯䐯杩䍩牥却䅈䠲杩䅨獳牵湡散敓癲牥䅃挮瑲ర̆ᵕē！Ȅ0രआ蘪虈෷āԋ̀Ƃ湐榝켘葁櫀Ც׆禮ጵ샍籖办鉘儏靇嫶?靤볓븴⋙严?뛙Ƥꎪ妉鬰阇靗슯ࣔᄼ㩔稆᯳ᗩ簟ᔥᚘ❽撋飢젶龾詤ﳡ㰿檕ꧻ벑瘅螖쑭鷬㷎샾㳱Ꜻᯋ眶ㄳ嗄췍܆兩ᴣ둷瀱꺔׷᳗郢跛儇ᡞ祈绑즏뤺벮摬娡텦ᘮ騙턲䳩돑ꤊ〩籺㊞␚觺뭐嗆ߗ⌔ド젳橹虐눁᧲䶍쵟뵅⛈ퟴ舰씃舰괂ΠĂȂȐ岬樦䀋辛礋껲╆ぷ؍⨉䢆čԁ氰଱र̆ѕጆ唂ㅓ〕ؓ唃਄ఓ楄楧敃瑲䤠据ᤱᜰ̆ѕጋ眐睷搮杩捩牥⹴潣ㅭ〫ة唃̄∓楄楧敃瑲䠠杩⁨獁畳慲据⁥噅删潯⁴䅃Ḱഗ㘰ㄱ〱〰〰〰᝚㌍ㄱㄱ〰〰〰娰氰଱र̆ѕጆ唂ㅓ〕ؓ唃਄ఓ楄楧敃瑲䤠据ᤱᜰ̆ѕጋ眐睷搮杩捩牥⹴潣ㅭ〫ة唃̄∓楄楧敃瑲䠠杩⁨獁畳慲据⁥噅删潯⁴䅃舰∁രआ蘪虈෷āԁ̀Ƃ舰ਁ舂ā였퓻ⴭ꘲㾁췉䤥熶쌪铕朴ઢ뀜楟䂦쒱늷킏꒘䆩㩙?횔?㡴䪤䷌舥䫷厥㠒浉酱捾ꮶ徦꓃扏빑엸?鈸ۣࣥ಑⣄啁쯻襚縕뼵牍㴉㪾倸睛ᬱ뎍Ⓡ驅겧m娔뜄Ꮊ凫頊䅁丢慥膇偁禦襜᧞坊⻕左匜縬춘ؚꐖ獨㓐ጄꅜ퍱籚?摞㟡ょіᇥ⦴ኀ秱蠹ʢ簑昧袷碷쫲ꠊꬸ搊뿂嵦蒕ꇁḥ嶇倚​찒뭁୮㡑䮸ˋăĀ掣愰ะ̆ᵕď！Єȃ蘁༰̆ᵕē！Ԅ̰āヿ؝唃ฝᘄᐄ㺱槃䞿퐁⚘ࠚ摣쌫ἰ̆ᵕУ〘耖넔쌾ͩ뿸Ň飔ᨦȈ揯⭤ッ؍⨉䢆čԁ舃āᰀؚ?鳗㲟暈ࠆ⅗⇛未뾪㈘䁶圐諁竳ᇙ蹥卑ﲞ땅?ㅌ롋ⱃ뎎칸祓홱⇥Ɣ嗚骇搤諶챦鳞촷㒨榱⎛黈≸瀫䝕愱았⾅ぎꃶᘱ젣ᙥ쬳ᪿꀛ廊ㆋ悋褈భ将띒龍頊ᗑ齟븒㙼㡣䒽群⛤ਫ韄൩賩샢圐좸ቶ喑䣲?⪼嬂䐏⃔?뫴♰遝鹠䮼ग됯ị桃߉섧峒뤡ቨ㲜뾜ﲞ岀掛ꩇ✥ꁧ舀命꧗ጮ瞣Ῠお҂ケ΂ꂙȃȁဂꓧ峜쁭䈫嶸鼕രआ蘪虈෷āԋ　ㅬ》؉唃؄ȓ单ᔱጰ̆ѕጊ䐌杩䍩牥⁴湉ㅣ〙ؗ唃଄ဓ睷⹷楤楧散瑲挮浯⬱⤰̆ѕጃ䐢杩䍩牥⁴楈桧䄠獳牵湡散䔠⁖潒瑯䌠ぁ᜞ㄍㄳ㈰ㄲ〲〰娰ഗ㠲〱㈲㈱〰〰ずㅰ》؉唃؄ȓ单ᔱጰ̆ѕጊ䐌杩䍩牥⁴湉ㅣ〙ؗ唃଄ဓ睷⹷楤楧散瑲挮浯⼱ⴰ̆ѕጃ䐦杩䍩牥⁴䡓㉁䠠杩⁨獁畳慲据⁥敓癲牥䌠ぁƂ〢؍⨉䢆čā舃༁　ƂȊƂ숯ؤ淈弄搊눆≽攦긖䁂캛鿜皟㸇ッ蝕뤙鑏娎ᾔ噕슴⨂킯䀋쓗㯐졲鸔郯ᆱ꺩죒䎸?ଋ헕꽀᷈䷭徜띗傆饨諵틚ׇꠟ즗ꓜ花ⶄ귆鲥ᧇꚂ྅䑞⩘輷㗽௱✈娲믵麋붤큑㯝㍂֣쐨⢻髌⮬ണ외煞䪷࠾臻ᚷꄖ⎝䴒ퟥ࢒疬鲤춺눗䐞攵卿㤥᳑騊᭣鈙桴㜊싂䡒㧋ꉚ셝ꃝ렠ꈡ⚓ᑯ⅊읁淭⽈ϳꋵ鉨⽓̂ꌁƂぉƂぅؒ唃ጝāӿ〈Ć！Ă　؎唃༝āӿ̄Ăゆ؝唃┝ᘄᐰࠆثԁ܅ăࠆثԁ܅ȃ㐰ࠆثԁ܅ā⠄☰␰ࠆثԁ܅İᢆ瑨灴⼺漯獣⹰楤楧散瑲挮浯䬰̆ᵕПいあꁀꀾ蘼栺瑴㩰⼯牣㑬搮杩捩牥⹴潣⽭楄楧敃瑲楈桧獁畳慲据䕥剖潯䍴⹁牣ぬؽ唃”㘄㐰㈰Іᵕ ⨰⠰ࠆثԁ܅Ăᰖ瑨灴㩳⼯睷⹷楤楧散瑲挮浯䌯卐ᴰ̆ᵕЎЖ儔ｨ꾐܂㱵?摥ꉢ렒牙〻؟唃⌝᠄ᘰᒀ㺱槃䞿퐁⚘ࠚ摣쌫രआ蘪虈෷āԋ̀Ƃ記覕?ﱜ栝䫪莏凖贯䑫鸖掬틵汮馄ꪋ熁宄㓭끎禷⦒ⷌ檀軰ꑹϾፇ쪆煙阄퍫塙︽㇓尥㠘ꎄ鿦ﶂ完㆘쵎鹸ﴚ쮅ꩉ⟲馋ﱲ꨾䇕?㛕뾡渜䥇广䣙ͼ﷙䦋颠䈦鋖ꐑ੤呗혝市걫쓮骀爒固힓뿿蔰〆ி乿埿鴅쎅שׂ疦겨ᘭ緯❹鷂܋ꫪ펅ꌁ⠠奁⡃臒ꫣ㭻뙷所ր䕁ؗ?㏀枛懓爮ﱩ䁗瀞ỵ듉1');
          //  Master.clientCert_x=PK; 
          //      Master.clientCertPasswd_x='S4Padmin';
          
          Master.inputHttpHeaders_x = new Map<String,String>();
          Master.timeout_x = 120000; //-- set timeout to 2 minutes (December 13, 2021 by doddy)

          String username = system.label.SAPUsername;//'xlsapint';
          String password = apputils.doDecrypt(system.label.SAPPassword);//'jakarta03';
          Blob headerValue = Blob.valueOf(username + ':' + password);
          String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
          Master.inputHttpHeaders_x.put('Authorization',authorizationHeader);
          Master.inputHttpHeaders_x.put('Content-Type', 'text/xml');
          try{
              result=Master.ZsfCustomerMaster(PackageAddress,PackageContact,Account);
              list<sapComDocumentSapSoapFunctionsMcSHANA.Zexdsdst00097> msg=new list<sapComDocumentSapSoapFunctionsMcSHANA.Zexdsdst00097>();
              sapComDocumentSapSoapFunctionsMcSHANA.Zexdsdtt00052 rslt=new sapComDocumentSapSoapFunctionsMcSHANA.Zexdsdtt00052();
              list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00038> listitem=new list<sapComDocumentSapSoapFunctionsMcSHANA.Zcrmsdst00038>();
              listitem=result.Item;
              rslt=listitem[0].Messages;
              msg=rslt.item;
               
              if(listitem[0].IsError=='')
                  status = 'Success';
              else if(listitem[0].IsError=='X')
                  status = 'Failed'; 
              
              update settings;
          }
          catch(exception e)
          {
              status = 'Failed';
              
              errMessage =  ' :: error message : ' + e.getmessage() 
                  + ' :: StacktraceString : ' + e.getstacktraceString() 
                  + ' :: LineNumber : ' + e.getLineNumber() 
                  + ' :: Cause  : ' + e.getcause();
              
              update settings;
          }
          
          //-- PUT CALL LOG
          Call_Log__c CL=new Call_Log__c();
          CL.Request_Start_Time__c = startTime;
          CL.CallerFrom__c  = 'Salesforce';
          CL.endpoint__c = Master.endpoint_x;
          CL.status__c = status;
          /*
          CL.Request_Message__c=String.valueof(' %% Contact : ' + JSON.serialize(PackageContact)
                                               + ' %%  AccountAddress : ' + JSON.serialize(PackageAddress)
                                               + ' %%  Account : '+ JSON.serialize(Account) );
          */
          CL.Request_Message__c=String.valueof('{ "Contact" :' + JSON.serialize(PackageContact) + ', '
                                               + ' "AccountAddress" : ' + JSON.serialize(PackageAddress)  + ', '
                                               + ' "Account" : '+ JSON.serialize(Account) + ' }'  );
          
          //CL.response_message__c=String.valueof(msg[0]);
          CL.response_message__c=String.valueof(JSON.serialize(result) );
          CL.error_message__c = errMessage;
          CL.response_end_time__c=system.now();
          CL.Type__c='Callout';
          insert CL;
      }
  }
  
}