/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-15-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class File_BAP_Attachment_Public_URL {
    @future(callout=true)
    public static void getURL(String BAPid,String BAPName) {

        try {
        system.debug ('== masuk File_BAP_Attachment_Public_URL ');
        PageReference pdf = page.Preview_IOM;
        pdf.getParameters().put('id',BAPid);
        Blob body=blob.valueof('tes');
        if(!test.isRunningTest())
        body = pdf.getContent();
        ContentVersion v = new ContentVersion();
                    v.versionData = body;
                    v.title = BAPName+'.pdf';
                    v.pathOnClient ='/';
                    insert v;
                    ContentVersion V2=[SELECT ContentDocumentID FROM Contentversion WHERE ID=:v.id];
                    ContentDocumentLink CDL=new ContentDocumentLink();
                    CDL.contentdocumentid=V2.ContentDocumentID;
                    CDL.linkedentityid=BAPid;
                    insert CDL;
                    ContentDistribution cd = new ContentDistribution();
                    cd.Name = BAPName;
                    cd.ContentVersionId = v.id;
                    cd.PreferencesAllowViewInBrowser= true;
                    cd.PreferencesLinkLatestVersion=true;
                    cd.PreferencesNotifyOnVisit=false;
                    cd.PreferencesPasswordRequired=false;
                    cd.PreferencesAllowOriginalDownload= true;
                    insert cd;
                    ContentDistribution CD2=[SELECT id,DistributionPublicUrl FROM ContentDistribution WHERE ID=:CD.id];
                    BAP__c B=new BAP__c();
                    B.id=BAPid;
                    B.iom_file_link__c=CD2.DistributionPublicUrl;
                    update B;
                    
                    
                    }
                    
        catch (Exception e) {
            string errMsg = 'Error on File_BAP_Attachment_Public_URL.getURL  method.:: ' + BAPName +' '
                + e.getmessage() + ' - ' +e.getStacktraceString() + '::' + e.getLineNumber();
                
            system.debug ('== errMsg : ' + errMsg );
            apputils.puterror(errMsg );
                    
        }
                    
                    
                    
    }
}