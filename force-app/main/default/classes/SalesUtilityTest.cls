@isTest
public class SalesUtilityTest
{
    public static User SalesUser(Id roleId, Id profID)
    {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
       
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User salesUser = new User(  firstname = 'Ahmat',
                                lastName = 'Murad',
                                email = uniqueName + '@test' + orgId + '.org',
                                Username = uniqueName + '@test' + orgId + '.org',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = uniqueName.substring(18, 23),
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = profId,
                                UserRoleId = roleId);
        return salesUser;
    }

	public static User GHUser(Id roleId, Id profID)
    {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
       
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User GHUser = new User(  
            Alias = 'ahmad',                                                              // Alias
            Email = 'ahmad@xl.co.id',                                                   // Email
            EmailEncodingKey='UTF-8',
            ProfileId = profID,                                                     // Profile
            Username = 'ahmad@xl.co.id',                                                // Username
            IsActive = true,   															 // Nickname
            ForecastEnabled = false,                                                     // Allow Forecasting
            Employee_ID__c = '900078723',                                                 // Employee ID
            phone ='021-90', 
            mobilephone='0812', 
            firstName = 'ahmad',
            LastName='murti',
            LocaleSidKey='en_US',
            TimeZoneSidKey=  'America/Los_Angeles',
            LanguageLocaleKey = 'en_US');
        return GHUser;
    }
    
    public static User SalesManagerUser(Id roleId, Id profID, Id Manager)
    {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
       
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User salesManagerUser = new User(  
            Alias = 'ngibrit',                                                            // Alias
            Email = 'ngibrit@xl.co.id',                                                  // Email
            EmailEncodingKey='UTF-8',
            Username = 'ngibrit@xl.co.id',                                               // Username
            IsActive = true,                                          
            LocaleSidKey='en_US',
            TimeZoneSidKey= 'America/Los_Angeles',
            LanguageLocaleKey = 'en_US', 
            Department = 'XL Business Solutions',                                          // Department
            ManagerId = Manager,                                                 // Manager
            ForecastEnabled = false,                                                       // Allow Forecasting
            MobilePhone = '+62 818161602',                                                 // Mobile
            Employee_ID__c = '90003712',                                               // Employee ID
            firstName = 'ngibrit',
            LastName='banget',
            ProfileId = profId,
            UserRoleId = roleId);
        return salesManagerUser;
    }
}