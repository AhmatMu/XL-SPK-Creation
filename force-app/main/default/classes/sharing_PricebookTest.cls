@isTest(SeeAllData=false)
private class sharing_PricebookTest {
    
    // Test for the manualShareRead method
    static testMethod void testManualShareRead(){
        
        // Select users for the test.
        List<User> users = [SELECT Id FROM User WHERE IsActive = true LIMIT 2];
        Id User1Id = users[0].Id;
        Id User2Id = users[1].Id;
        
        Pricebook2 priceBook = new Pricebook2(
            Name = 'Example Price Book',
            Description = 'This is the Price Book description.',
            IsActive = true
        );
        
        insert priceBook;
        
        // Create a Product
        
        Product2 product = new Product2(
            Name = 'Example Product',
            Description = 'This is the Product description.',
            ProductCode = 'EX1234',
            StockKeepingUnit = 'EX5678',
            Family = 'Example Product Family',
            QuantityUnitOfMeasure = 'inches',
            DisplayUrl = 'https://www.example.com/',
            ExternalId = 'ID #1234',
            ExternalDataSourceId = '0XCXXXXXXXXXXXXXXX',
            IsActive = true
        );
        
        insert product;
        
        // Get the Standard Price Book ID
        
        Pricebook2 standardPriceBook = [
            SELECT Id
            FROM Pricebook2
            WHERE isStandard = true
            LIMIT 1
        ];
        
        // Insert the Product in the Standard Price Book (if necessary)
        
        PricebookEntry standardPriceBookEntry = new PricebookEntry(
            Pricebook2Id = standardPriceBook.Id,
            Product2Id = product.Id,
            UnitPrice = 100.00,
            UseStandardPrice = false,
            IsActive = true
        );
        
        insert standardPriceBookEntry;
        
        // Insert the Product in the New Price Book
        
        PricebookEntry priceBookEntry = new PricebookEntry(
            Pricebook2Id = priceBook.Id,
            Product2Id = product.Id,
            UnitPrice = 100.00,
            UseStandardPrice = false,
            IsActive = true
        );
        
        insert priceBookEntry;
        
    }  
}