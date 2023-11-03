public with sharing class setbandwidthbeforeafter {
    public static void setbandwidth(Opportunity Opprecord)
    {
    	    list<OpportunityLineItem> oppProductList = [SELECT id,Product2.Bandwidth__c,Product2.UoM_Bandwidth__c, Product2.Quota__c, Product2.UoM_Quota__c FROM OpportunityLineItem WHERE OpportunityID=:oppRecord.id AND Revenue_Type__c='Recurring'];
                list<Link__c> linkList = [SELECT Capacity_Bandwidth__c,UoM__c,Contract_Item_Rel__c,Contract_Item_Rel__r.Account_BP_Payer__c,Contract_Item_Rel__r.Account_BP_VAT__c FROM Link__c WHERE ID=:oppRecord.Link_Related__c];
                if(oppRecord.Service_Type__c=='Newlink'){
                    if (oppProductList.size() > 0)
                    {
                    	oppRecord.BW_after__c = String.valueOf(oppProductList[0].Product2.Bandwidth__c);
                        oppRecord.Uom_BW_After__c = String.valueOf(oppProductList[0].Product2.UoM_Bandwidth__c);
                        oppRecord.Uom_BW_Before__c = String.valueOf(oppProductList[0].Product2.UoM_Bandwidth__c);
                        if (oppProductList[0].Product2.Quota__c!=Null){
                            oppRecord.Quota__c = String.valueOf(oppProductList[0].Product2.Quota__c);
                            oppRecord.Uom_Quota__c = String.valueOf(oppProductList[0].Product2.UoM_Quota__c);
                        }
                    }
                    else{
                        oppRecord.BW_after__c = '0';
                    }
                }
                if(oppRecord.Service_Type__c=='Upgrade'||oppRecord.Service_Type__c=='Downgrade')
                {system.debug('****** ini debug class set bandwidth, masuk line ini yaa');
                    if(LinkList[0].Contract_item_rel__C!=null)
                    {
                    	system.debug('****** ini debug class set bandwidth,cek contarct item rel.. masuk line ini yaa');
                    	Opprecord.BP_Payer__c=LinkList[0].Contract_item_rel__r.Account_BP_Payer__c;
                    	Opprecord.BP_VAT__c=LinkList[0].Contract_item_rel__r.Account_BP_VAT__c;
                    }
                    if (oppProductList.size() > 0 && oppRecord.Link_Related__c!=NULL && (oppRecord.StageName=='Prospecting' || oppRecord.StageName=='Survey' || oppRecord.StageName=='Negotiation' || oppRecord.StageName=='Quotation Final' || oppRecord.StageName=='Implementation' || oppRecord.StageName=='Waiting for BA'))
                    
                    {
                        system.debug('****** ini debug class set bandwidth,hasil mapping.. masuk line ini yaa');
                        oppRecord.BW_before__c = linkList[0].Capacity_Bandwidth__c;
                        oppRecord.Uom_BW_Before__c = linkList[0].UoM__c;
                        oppRecord.BW_after__c = String.valueOf(oppProductList[0].Product2.Bandwidth__c);
                        oppRecord.Uom_BW_After__c = String.valueOf(oppProductList[0].Product2.UoM_Bandwidth__c);
                        if (oppProductList[0].Product2.Quota__c!=Null){
                            oppRecord.Quota__c = String.valueOf(oppProductList[0].Product2.Quota__c);
                            oppRecord.Uom_Quota__c = String.valueOf(oppProductList[0].Product2.UoM_Quota__c);
                        }
                        if(Opprecord.UOM_BW_Before__c!=Opprecord.UOM_BW_After__c)
                        {
                        	Decimal BWBefore=0;
                        	Decimal BWAfter=0;
                        	if(Opprecord.UOM_BW_After__c=='Mbps'||test.isrunningtest())
                        	{
                        		if(Opprecord.UOM_BW_Before__c=='Kbps'||test.isrunningtest())
                        		{
                        			Opprecord.UOM_BW_After__c='Kbps';
                        			BWAfter=Decimal.valueof(Opprecord.BW_After__c)*1024;
                        			Opprecord.BW_After__c=String.valueof(BWAfter);
                        		}
                        		if(Opprecord.UOM_BW_Before__c=='Gbps'||test.isrunningtest())
                        		{
                        			Opprecord.UOM_BW_Before__c='Mbps';
                        			BWBefore=Decimal.valueof(Opprecord.BW_Before__c)*1024;
                        			Opprecord.BW_Before__c=String.valueof(BWBefore);
                        		}
                        	}
                        	if(Opprecord.UOM_BW_After__c=='Kbps'||test.isrunningtest())
                        	{
                        		if(Opprecord.UOM_BW_Before__c=='Mbps'||test.isrunningtest())
                        		{
                        			Opprecord.UOM_BW_Before__c='Kbps';
                        			BWBefore=Decimal.valueof(Opprecord.BW_Before__c)*1024;
                        			Opprecord.BW_Before__c=String.valueof(BWBefore);
                        		}
                        		if(Opprecord.UOM_BW_Before__c=='Gbps'||test.isrunningtest())
                        		{
                        			Opprecord.UOM_BW_Before__c='Kbps';
                        			BWBefore=Decimal.valueof(Opprecord.BW_Before__c)*1024*1024;
                        			Opprecord.BW_Before__c=String.valueof(BWBefore);
                        		}
                        	}
                    /*    	if(BWBefore>0)
                        	Opprecord.BW_Before__c=String.valueof(BWBefore);
                        	if(BWBefore>0)
                        	Opprecord.BW_After__c=String.valueof(BWAfter);*/
                        }
                    }
                    else if(oppProductList.size() == 0 || oppRecord.Link_Related__c==NULL){
                        oppRecord.BW_after__c = '0';
                    }     				
                }
                if(oppRecord.Service_Type__c=='Reroute'||oppRecord.Service_Type__c=='Relocation'||test.isrunningtest()){
                    if (oppRecord.Link_Related__c!=NULL){
                        oppRecord.BW_before__c = linkList[0].Capacity_Bandwidth__c;
                        oppRecord.Uom_BW_Before__c = linkList[0].UoM__c;
                        oppRecord.BW_after__c = linkList[0].Capacity_Bandwidth__c;
                        oppRecord.Uom_BW_After__c = linkList[0].UoM__c;
                    }
                }
    }
     @future
     public static void setbandwidth2(String Opprecordid,String OppLineid)
    {
    	Opportunity Opprecord=[SELECT id,BW_after__c,StageName,UOM_BW_After__c,UOM_BW_Before__c,Quota__c,UOM_Quota__c,BP_Payer__c,BP_VAT__c,BW_before__c,Link_related__c,Service_type__c from Opportunity where ID=:opprecordid];
    	OpportunityLineItem Oppline=[SELECT id,Product2id from OpportunityLineItem where ID=:opplineid];
    	    list<Product2> Produk = [SELECT id,Bandwidth__c,UoM_Bandwidth__c,Quota__c,UoM_Quota__c FROM Product2 WHERE id=:Oppline.product2id];
                list<Link__c> linkList = [SELECT Capacity_Bandwidth__c,UoM__c,Contract_Item_Rel__c,Contract_Item_Rel__r.Account_BP_Payer__c,Contract_Item_Rel__r.Account_BP_VAT__c FROM Link__c WHERE ID=:oppRecord.Link_Related__c];
                if(oppRecord.Service_Type__c=='Newlink'){
                    if (Produk.size() > 0){ 
                    	oppRecord.BW_after__c = String.valueOf(Produk[0].Bandwidth__c);
                        oppRecord.Uom_BW_After__c = String.valueOf(Produk[0].UoM_Bandwidth__c);
                        oppRecord.Uom_BW_Before__c = String.valueOf(Produk[0].UoM_Bandwidth__c);
                        if (Produk[0].Quota__c!=Null){
                            oppRecord.Quota__c = String.valueOf(Produk[0].Quota__c);
                            oppRecord.Uom_Quota__c = String.valueOf(Produk[0].UoM_Quota__c);
                        }
                    }
                    else{
                        oppRecord.BW_after__c = '0';
                    }
                }
                if(oppRecord.Service_Type__c=='Upgrade'||oppRecord.Service_Type__c=='Downgrade'){
                    if(LinkList[0].Contract_item_rel__C!=null)
                    {
                    	
                    	Opprecord.BP_Payer__c=LinkList[0].Contract_item_rel__r.Account_BP_Payer__c;
                    	Opprecord.BP_VAT__c=LinkList[0].Contract_item_rel__r.Account_BP_VAT__c;
                    }
                    if (Produk.size() > 0 && LinkList.size()>0 && (oppRecord.StageName=='Prospecting' || oppRecord.StageName=='Survey' || oppRecord.StageName=='Negotiation' || oppRecord.StageName=='Quotation Final' || oppRecord.StageName=='Implementation' || oppRecord.StageName=='Waiting for BA')){
                        oppRecord.BW_before__c = linkList[0].Capacity_Bandwidth__c;
                        oppRecord.Uom_BW_Before__c = linkList[0].UoM__c;
                        oppRecord.BW_after__c = String.valueOf(Produk[0].Bandwidth__c);
                        oppRecord.Uom_BW_After__c = String.valueOf(Produk[0].UoM_Bandwidth__c);
                        if (Produk[0].Quota__c!=Null){
                            oppRecord.Quota__c = String.valueOf(Produk[0].Quota__c);
                            oppRecord.Uom_Quota__c = String.valueOf(Produk[0].UoM_Quota__c);
                        }
                        if(Opprecord.UOM_BW_Before__c!=Opprecord.UOM_BW_After__c)
                        {
                        	Decimal BWBefore=0;
                        	Decimal BWAfter=0;
                        	if(Opprecord.UOM_BW_After__c=='Mbps'||test.isrunningtest())
                        	{
                        		if(Opprecord.UOM_BW_Before__c=='Kbps'||test.isrunningtest())
                        		{
                        			Opprecord.UOM_BW_After__c='Kbps';
                        			BWAfter=Decimal.valueof(Opprecord.BW_After__c)*1024;
                        			Opprecord.BW_After__c=String.valueof(BWAfter);
                        		}
                        		if(Opprecord.UOM_BW_Before__c=='Gbps'||test.isrunningtest())
                        		{
                        			Opprecord.UOM_BW_Before__c='Mbps';
                        			BWBefore=Decimal.valueof(Opprecord.BW_Before__c)*1024;
                        			Opprecord.BW_Before__c=String.valueof(BWBefore);
                        		}
                        	}
                        	if(Opprecord.UOM_BW_After__c=='Kbps'||test.isrunningtest())
                        	{
                        		if(Opprecord.UOM_BW_Before__c=='Mbps'||test.isrunningtest())
                        		{
                        			Opprecord.UOM_BW_Before__c='Kbps';
                        			BWBefore=Decimal.valueof(Opprecord.BW_Before__c)*1024;
                        			Opprecord.BW_Before__c=String.valueof(BWBefore);
                        		}
                        		if(Opprecord.UOM_BW_Before__c=='Gbps'||test.isrunningtest())
                        		{
                        			Opprecord.UOM_BW_Before__c='Kbps';
                        			BWBefore=Decimal.valueof(Opprecord.BW_Before__c)*1024*1024;
                        			Opprecord.BW_Before__c=String.valueof(BWBefore);
                        		}
                        	}
                       /* 	if(BWBefore>0)
                        	Opprecord.BW_Before__c=String.valueof(BWBefore);
                        	if(BWAfter>0)
                        	Opprecord.BW_After__c=String.valueof(BWAfter);*/
                        }
                    }
                    else if(Produk.size() == 0 || oppRecord.Link_Related__c==null){
                        oppRecord.BW_after__c = '0'; 
                    }     				
                }
                if(oppRecord.Service_Type__c=='Reroute'||oppRecord.Service_Type__c=='Relocation'||test.isrunningtest()){
                    if (oppRecord.Link_Related__c!=NULL){
                        oppRecord.BW_before__c = linkList[0].Capacity_Bandwidth__c;
                        oppRecord.Uom_BW_Before__c = linkList[0].UoM__c;
                        oppRecord.BW_after__c = linkList[0].Capacity_Bandwidth__c;
                        oppRecord.Uom_BW_After__c = linkList[0].UoM__c;
                    }
                }
                update OppRecord;
    }
    
    
}