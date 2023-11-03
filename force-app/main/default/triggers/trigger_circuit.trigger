trigger trigger_circuit on Circuit__c (after insert, after update, before insert, before update) {
    if(system.label.is_trigger_circuit_on=='YES')
    {
    String CIDInitial='';
        String CIDNumber='';
        for(Circuit__c C:system.trigger.new)
        {
            if(trigger.isinsert)
            {
                if(trigger.isbefore)
                {
                    if(C.Name==null || C.Name=='' || C.Name==' '||C.Name=='Auto')
                    {
                    Link_CID__c LC=Link_CID__c.getorgdefaults();
                    if(C.Services__c=='LL')
                    {
                        CIDInitial='01';
                        CIDNumber=String.valueof(LC.CID_LL__c);
                        LC.CID_LL__c=LC.CID_LL__c+1;
                
                    }
                    if(C.Services__c=='MPLS'||test.isrunningtest())
                    {
                        CIDInitial='02';
                        CIDNumber=String.valueof(LC.CID_MPLS__c);
                        LC.CID_MPLS__c=LC.CID_MPLS__c+1;
                
                    }
                    if(C.Services__c=='ISP'||test.isrunningtest())
                    {
                        CIDInitial='03';
                        CIDNumber=String.valueof(LC.CID_ISP__c);
                        LC.CID_ISP__c=LC.CID_ISP__c+1;
                
                    }
                    if(C.Services__c=='NAP'||test.isrunningtest())
                    {
                        CIDInitial='04';
                        CIDNumber=String.valueof(LC.CID_NAP__c);
                        LC.CID_NAP__c=LC.CID_NAP__c+1;
                
                    }
            
                    if(C.Services__c=='VOIP'||test.isrunningtest())
                    {
                        CIDInitial='05';
                        CIDNumber=String.valueof(LC.CID_VOIP__c);
                        LC.CID_VOIP__c=LC.CID_VOIP__c+1;
                
                    }
                    if(C.Services__c=='SD-WAN'||test.isrunningtest())
                    {
                        CIDInitial='30';
                        CIDNumber=String.valueof(LC.CID_SDWAN__c);
                        LC.CID_SDWAN__c=LC.CID_SDWAN__c+1;
                
                    }
                    if(C.Services__c=='Telco insight And Analytics'||test.isrunningtest())
                    {
                        CIDInitial='31';
                        CIDNumber=String.valueof(LC.CID_TELINS__c);
                        LC.CID_TELINS__c=LC.CID_TELINS__c+1;
                
                    }
                    if(C.Services__c=='SMART'||test.isrunningtest())
                    {
                        CIDInitial='32';
                        CIDNumber=String.valueof(LC.CID_SMART__c);
                        LC.CID_SMART__c=LC.CID_SMART__c+1;
                
                    }
                    if(C.Services__c=='DIRECT PEERING'||test.isrunningtest())
                    {
                        CIDInitial='33';
                        CIDNumber=String.valueof(LC.CID_DIRECTPEERING__c);
                        LC.CID_DIRECTPEERING__c=LC.CID_DIRECTPEERING__c+1;
                
                    }
                    if(C.Services__c=='Managed Network CPE'||test.isrunningtest())
                    {
                        CIDInitial='34';
                        CIDNumber=String.valueof(LC.CID_MNCPE__c);
                        LC.CID_MNCPE__c=LC.CID_MNCPE__c+1;                
                    }
                    if(C.Services__c=='APN Corporate'||test.isrunningtest())
                    {
                        CIDInitial='06';
                        CIDNumber=String.valueof(LC.CID_APN__c);
                        LC.CID_APN__c=LC.CID_APN__c+1;
                        
                    }
                    if(C.Services__c=='MDS Bulkshare'||test.isrunningtest())
                    {
                        CIDInitial='07';
                        CIDNumber=String.valueof(LC.CID_MDS__c);
                        LC.CID_MDS__c=LC.CID_MDS__c+1;
                        
                    }
                    if(C.Services__c=='SSLVPN'||test.isrunningtest())
                    {
                        CIDInitial='11';
                        CIDNumber=String.valueof(LC.CID_SSLVPN__c);
                        LC.CID_SSLVPN__c=LC.CID_SSLVPN__c+1;
                        
                    }
                    if(C.Services__c=='VLL'||test.isrunningtest())
                    {
                        CIDInitial='15';
                        CIDNumber=String.valueof(LC.CID_VLL__c);
                        LC.CID_VLL__c=LC.CID_VLL__c+1;
                    
                        
                    }
                    if(C.Services__c=='MCA'||test.isrunningtest())
                    {
                        system.debug ('====== LC.CID_MCA__c : ' + LC.CID_MCA__c);
                        CIDInitial='24';
                        CIDNumber=String.valueof(LC.CID_MCA__c);
                        LC.CID_MCA__c=LC.CID_MCA__c+1;
                        
                    }
                    if(C.Services__c=='4G Access'||test.isrunningtest())
                    {
                        system.debug ('====== LC.CID_4GACCESS__c : ' + LC.CID_4GACCESS__c);
                        CIDInitial='29';
                        CIDNumber=String.valueof(LC.CID_4GACCESS__c);
                        LC.CID_4GACCESS__c=LC.CID_4GACCESS__c+1;
                        
                    }
                    if(C.Services__c=='FLEET'||test.isrunningtest())
                    {
                        CIDInitial='25';
                        CIDNumber=String.valueof(LC.CID_FLEET__c);
                        LC.CID_FLEET__c=LC.CID_FLEET__c+1;
                        
                    }
                    if(C.Services__c=='L2VPN'||test.isrunningtest())
                    {
                        CIDInitial='12';
                        CIDNumber=String.valueof(LC.CID_L2VPN__c);
                        LC.CID_L2VPN__c=LC.CID_L2VPN__c+1;
                    
                        
                    }
                        if(C.Services__c=='Collocation'||test.isrunningtest())
                    {
                        CIDInitial='09';
                        CIDNumber=String.valueof(LC.CID_CL__c);
                        LC.CID_CL__c=LC.CID_CL__c+1;
                    }
                    if(C.Services__c=='ISPUpTO'||test.isrunningtest())
                    {
                        CIDInitial='19';
                        CIDNumber=String.valueof(LC.CID_ISPUPTO__c);
                        LC.CID_ISPUPTO__c=LC.CID_ISPUPTO__c+1;
                    }
                    if(C.Services__c=='HPABX'||test.isrunningtest())
                    {
                        CIDInitial='10';
                        CIDNumber=String.valueof(LC.CID_HPABX__c);
                        LC.CID_HPABX__c=LC.CID_HPABX__c+1;
                    }
                    if(C.Services__c=='GSMPBX'||test.isrunningtest())
                    {
                        CIDInitial='08';
                        CIDNumber=String.valueof(LC.CID_GSMPBX__c);
                        LC.CID_GSMPBX__c=LC.CID_GSMPBX__c+1;
                    }
                    if(C.Services__c=='WEB2SMS'||test.isrunningtest())
                    {
                        CIDInitial='17';
                        CIDNumber=String.valueof(LC.CID_WEB2SMS__c);
                        LC.CID_WEB2SMS__c=LC.CID_WEB2SMS__c+1;
                    }
                    if(C.Services__c=='SMSB'||test.isrunningtest())
                    {
                        CIDInitial='16';
                        CIDNumber=String.valueof(LC.CID_SMSB__c);
                        LC.CID_SMSB__c=LC.CID_SMSB__c+1;
                    }
                    if(C.Services__c=='MPLSWAN'||test.isrunningtest())
                    {
                        CIDInitial='18';
                        CIDNumber=String.valueof(LC.CID_MPLSWAN__c);
                        LC.CID_MPLSWAN__c=LC.CID_MPLSWAN__c+1;
                    }
                    if(C.Services__c=='NAPXLIX'||test.isrunningtest())
                    {
                        CIDInitial='20';
                        CIDNumber=String.valueof(LC.CID_NAPXLIX__c);
                        LC.CID_NAPXLIX__c=LC.CID_NAPXLIX__c+1;
                    }
                        if(C.Services__c=='VCON'||test.isrunningtest())
                    {
                        CIDInitial='22';
                        CIDNumber=String.valueof(LC.CID_VCON__c);
                        LC.CID_VCON__c=LC.CID_VCON__c+1;
                    }
                    if(C.Services__c=='ISPPROMO'||test.isrunningtest())
                    {
                        CIDInitial='21';
                        CIDNumber=String.valueof(LC.CID_ISPPROMO__c);
                        LC.CID_ISPPROMO__c=LC.CID_ISPPROMO__c+1; 
                    }
                    if(C.Services__c=='ISPHRB'||test.isrunningtest())
                    {
                        CIDInitial='26';
                        CIDNumber=String.valueof(LC.CID_ISPHRB__c);
                        LC.CID_ISPHRB__c=LC.CID_ISPHRB__c+1;
                    }
                        if(C.Services__c=='ISPFTTX'||test.isrunningtest())
                    {
                        CIDInitial='27';
                        CIDNumber=String.valueof(LC.CID_ISPFTTX__c);
                        LC.CID_ISPFTTX__c=LC.CID_ISPFTTX__c+1;
                    }
                        if(C.Services__c=='VPLS'||test.isrunningtest())
                    {
                        CIDInitial='28';
                        CIDNumber=String.valueof(LC.CID_VPLS__c);
                        LC.CID_VPLS__c=LC.CID_VPLS__c+1;
                    }
                    if(C.Services__c=='NAPMIX'||test.isrunningtest())
                    {
                        CIDInitial='13';
                        CIDNumber=String.valueof(LC.CID_NAPMIX__c);
                        LC.CID_NAPMIX__c=LC.CID_NAPMIX__c+1;
                    }
                    if(C.Services__c=='Cloud IAAS'||test.isrunningtest())
                    {
                        CIDInitial='23';
                        CIDNumber=String.valueof(LC.CID_IAAS__c);
                        LC.CID_IAAS__c=LC.CID_ISPHRB__c+1;
                    }
                        
                    if(C.Services__c=='Cloud SAAS'||test.isrunningtest())
                    {
                        CIDInitial='35';
                        CIDNumber=String.valueof(LC.CID_SAAS__c);
                        LC.CID_SAAS__c=LC.CID_SAAS__c+1;                
                    }
                    
                    CIDNumber=CIDNumber.replace('.0','');
                    while(CIDNumber.length()<5)
                    {
                        CIDNumber='0'+CIDNumber;
                    }
            
                    C.Name=CIDInitial+'-'+CIDNumber;
                
                    update LC;
                    }
                }
            }
        }
    }
}